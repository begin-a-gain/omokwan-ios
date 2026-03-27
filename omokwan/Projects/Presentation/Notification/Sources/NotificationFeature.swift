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
    @Dependency(\.gameUseCase) private var gameUseCase
    @Dependency(\.analyticsUseCase) private var analyticsUseCase
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case participateDoubleCheck(NotificationInfo)
            case password(NotificationInfo)
            case passwordError
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        var isProgressLoading: Bool = false
        var selectedFilter: NotificationFilter = .all
        var thousandsPlace: String = ""
        var hundredsPlace: String = ""
        var tensPlace: String = ""
        var onesPlace: String = ""
        var unreadNotificationCount: Int {
            notifications.filter { !$0.isRead }.count
        }
        var notifications: [NotificationInfo] = []
        var unReadNotifications: [NotificationInfo] {
            notifications.filter { !$0.isRead }
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case navigateToGameDetail(Int, String, String)
        case binding(BindingAction<State>)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case notificationsFetched([NotificationInfo])
        case settingButtonTapped
        case filterButtonTapped(NotificationFilter)
        case readAllButtonTapped
        case fetchNotificationInfo
        case notificationCardTapped(NotificationInfo)
        case alertParticipateButtonTapped(NotificationInfo)
        case passwordAlertCancelButtonTapped
        case passwordAlertConfirmButtonTapped(NotificationInfo)
        case readNotification(NotificationInfo)
        case notificationReadSucceeded(NotificationInfo)
        case participateNotification(NotificationInfo, String?)
        case participateCompleted(NotificationInfo)
        case readAllNotifications
        case allNotificationsReadSucceeded
        case setProgressLoading(Bool)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
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
                analyticsUseCase.track(.enterDetailFromNotification)
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
                if notificationInfo.isPublic {
                    return .merge([
                        .send(.alertAction(.dismiss)),
                        .send(.participateNotification(notificationInfo, nil))
                    ])
                }
                
                state.alertCase = .password(notificationInfo)
                return .none
            case .passwordAlertCancelButtonTapped:
                return .send(.alertAction(.dismiss))
            case .passwordAlertConfirmButtonTapped(let notificationInfo):
                guard let password = [
                    state.thousandsPlace,
                    state.hundredsPlace,
                    state.tensPlace,
                    state.onesPlace
                ].passwordString else {
                    return .none
                }
                
                return .merge([
                    .send(.alertAction(.dismiss)),
                    .send(.participateNotification(notificationInfo, password))
                ])
            case .readNotification(let notificationInfo):
                return .concatenate([
                    .send(.setProgressLoading(true)),
                    .run { send in
                        await send(readNotification(notificationInfo))
                    }
                ])
            case let .participateNotification(notificationInfo, password):
                return .concatenate([
                    .send(.setProgressLoading(true)),
                    .run { send in
                        await send(participateNotification(notificationInfo, password))
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
                
                return .concatenate([
                    .send(.setProgressLoading(false)),
                    .send(.navigateToGameDetail(notificationInfo.gameID, notificationInfo.title, selectedDateString))
                ])
            case .participateCompleted(let notificationInfo):
                analyticsUseCase.track(.participateSuccessFromNotification)
                return .send(.notificationReadSucceeded(notificationInfo))
            case .allNotificationsReadSucceeded:
                analyticsUseCase.track(.notificationReadAllSuccess)
                state.notifications = state.notifications.map {
                    NotificationInfo(
                        id: $0.id,
                        gameID: $0.gameID,
                        isPublic: $0.isPublic,
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
            case .binding:
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
    
    func participateNotification(_ notificationInfo: NotificationInfo, _ password: String?) async -> Action {
        let readResponse = await notificationUseCase.patchNotificationRead(notificationInfo.id)
        
        switch readResponse {
        case .success:
            let response = await gameUseCase.participateRoom(notificationInfo.gameID, password)
            
            switch response {
            case .success(let isParticipateSuccess):
                return isParticipateSuccess
                    ? .participateCompleted(notificationInfo)
                    : .showAlert(.passwordError)
            case .failure(let error):
                return .showAlert(.error(error))
            }
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
            gameID: notification.gameID,
            isPublic: notification.isPublic,
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
