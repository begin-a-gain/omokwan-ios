//
//  NotificationFeature.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture
import Domain

@Reducer
public struct NotificationFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        var selectedFilter: NotificationFilter = .all
        var unreadNotificationCount: Int = 10
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case settingButtonTapped
        case filterButtonTapped(NotificationFilter)
        case readAllButtonTapped
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
            }
        }
    }
}
