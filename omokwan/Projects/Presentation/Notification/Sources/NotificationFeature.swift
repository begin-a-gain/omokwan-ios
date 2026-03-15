//
//  NotificationFeature.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct NotificationFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {
            self.notifications = [
                NotificationInfo(
                    id: 1,
                    isRead: false,
                    createdDate: .now,
                    type: .joined,
                    title: "모기",
                    targetName: "수요오목방",
                    previousHostName: "오목이",
                    newHostName: "모기"
                ),
                NotificationInfo(
                    id: 2,
                    isRead: false,
                    createdDate: .now.addingTimeInterval(-3600),
                    type: .invited,
                    title: "바둑이",
                    targetName: "주말 오목 모임",
                    previousHostName: nil,
                    newHostName: nil
                ),
                NotificationInfo(
                    id: 3,
                    isRead: true,
                    createdDate: .now.addingTimeInterval(-7200),
                    type: .left,
                    title: "호호",
                    targetName: "새벽반",
                    previousHostName: nil,
                    newHostName: nil
                ),
                NotificationInfo(
                    id: 4,
                    isRead: true,
                    createdDate: .now.addingTimeInterval(-7200),
                    type: .hostChanged,
                    title: "꺌꺌",
                    targetName: "새벽반",
                    previousHostName: "나는야빡빡이",
                    newHostName: "나는갹갹이다"
                )

            ]
            self.unreadNotificationCount = notifications.filter { !$0.isRead }.count
        }
        
        var isLoading: Bool = false
        var selectedFilter: NotificationFilter = .all
        var unreadNotificationCount: Int = 0
        var notifications: [NotificationInfo] = []
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case settingButtonTapped
        case filterButtonTapped(NotificationFilter)
        case readAllButtonTapped
        case notificationCardTapped(NotificationInfo)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .navigateToBack:
                return .none
            case .settingButtonTapped:
                // TODO: Navigate To Setting
                return .none
            case .filterButtonTapped(let type):
                state.selectedFilter = type
                return .none
            case .readAllButtonTapped:
                return .none
            case .notificationCardTapped:
                return .none
            }
        }
    }
}
