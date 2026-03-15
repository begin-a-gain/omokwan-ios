//
//  NotificationFeature.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture

@Reducer
public struct NotificationFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case settingButtonTapped
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
            }
        }
    }
}
