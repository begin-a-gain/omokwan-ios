//
//  NotificationFeature.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture
import Domain
import Base
import Util
import Foundation

@Reducer
public struct NotificationFeature {
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case participateDoubleCheck(NotificationInfo)
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        var isProgressLoading: Bool = false
        var selectedFilter: NotificationFilter = .all
        var unreadNotificationCount: Int {
            notifications.filter { !$0.isRead }.count
        }
        var notifications: [NotificationInfo] = []
        var unReadNotifications: [NotificationInfo] {
            notifications.filter { !$0.isRead }
        }
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case navigateToGameDetail(Int, String, String)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case notificationsFetched([NotificationInfo])
        case settingButtonTapped
        case filterButtonTapped(NotificationFilter)
        case readAllButtonTapped
        case fetchNotificationInfo
        case notificationCardTapped(NotificationInfo)
        case alertParticipateButtonTapped(NotificationInfo)
        case readNotification(NotificationInfo)
        case notificationReadSucceeded(NotificationInfo)
        case readAllNotifications
        case allNotificationsReadSucceeded
        case setProgressLoading(Bool)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchNotificationInfo)
            case .fetchNotificationInfo:
                state.isLoading = true
                return .run { [filter = state.selectedFilter] send in
                    await send(fetchNotificationList(filter))
                }
            case .navigateToBack:
                return .none
            case .navigateToGameDetail:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.isProgressLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .notificationsFetched(let notifications):
                state.notifications = notifications
                state.isLoading = false
                return .none
            case .settingButtonTapped:
                // TODO: Navigate To Setting
                return .none
            case .filterButtonTapped(let type):
                guard state.selectedFilter != type else { return .none }
                
                state.selectedFilter = type
                return .none
            case .readAllButtonTapped:
                return .send(.readAllNotifications)
            case .notificationCardTapped(let notificationInfo):
                guard notificationInfo.type != .invited else {
                    return .send(.showAlert(.participateDoubleCheck(notificationInfo)))
                }
                
                return .send(.readNotification(notificationInfo))
            case .alertParticipateButtonTapped(let notificationInfo):
                return .concatenate([
                    .send(.alertAction(.dismiss)),
                    .send(.readNotification(notificationInfo))
                ])
            case .readNotification(let notificationInfo):
                return .concatenate([
                    .send(.setProgressLoading(true)),
                    .run { send in
                        await send(readNotification(notificationInfo))
                    }
                ])
            case .readAllNotifications:
                return .concatenate([
                    .send(.setProgressLoading(true)),
                    .run { send in
                        await send(readAllNotifications())
                    }
                ])
            case .notificationReadSucceeded(let notificationInfo):
                updateNotificationStatus(notificationInfo.id, state: &state)
                
                let selectedDateString = Date.now.formattedString(
                    format: DateFormatConstants.yearMonthDayRequestFormat
                )
                
                // TODO: 여기 noti id말고, gameID를 넘겨야하는데, 서버에서 아직 작업이 되지 않음. 작업이 완료될 시 gameID로 바꾸도록.
                return .concatenate([
                    .send(.setProgressLoading(false)),
                    .send(.navigateToGameDetail(notificationInfo.id, notificationInfo.title, selectedDateString))
                ])
            case .allNotificationsReadSucceeded:
                state.notifications = state.notifications.map {
                    NotificationInfo(
                        id: $0.id,
                        isRead: true,
                        createdDate: $0.createdDate,
                        type: $0.type,
                        title: $0.title,
                        targetName: $0.targetName,
                        previousHostName: $0.previousHostName,
                        newHostName: $0.newHostName
                    )
                }
                return .send(.setProgressLoading(false))
            case .setProgressLoading(let value):
                state.isProgressLoading = value
                return .none
            case .alertAction:
                return .none
            }
        }
    }
}

private extension NotificationFeature {
    func fetchNotificationList(_ filter: NotificationFilter) async -> Action {
        let response = await notificationUseCase.fetchNotificationList(filter)
        
        switch response {
        case .success(let notifications):
            return .notificationsFetched(notifications)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func readNotification(_ notificationInfo: NotificationInfo) async -> Action {
        let response = await notificationUseCase.patchNotificationRead(notificationInfo.id)
        
        switch response {
        case .success:
            return .notificationReadSucceeded(notificationInfo)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func readAllNotifications() async -> Action {
        let response = await notificationUseCase.patchNotificationRead(nil)
        
        switch response {
        case .success:
            return .allNotificationsReadSucceeded
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func updateNotificationStatus(_ id: Int, state: inout State) {
        guard let index = state.notifications.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        let notification = state.notifications[index]
        state.notifications[index] = NotificationInfo(
            id: notification.id,
            isRead: true,
            createdDate: notification.createdDate,
            type: notification.type,
            title: notification.title,
            targetName: notification.targetName,
            previousHostName: notification.previousHostName,
            newHostName: notification.newHostName
        )
    }
}
