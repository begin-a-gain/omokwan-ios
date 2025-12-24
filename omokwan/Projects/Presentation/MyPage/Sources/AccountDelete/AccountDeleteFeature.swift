//
//  AccountDeleteFeature.swift
//  MyPage
//
//  Created by 김동준 on 11/24/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct AccountDeleteFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        @Shared(.userInfo) var userInfo = UserInfo()
        var isLoading: Bool = false
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .binding:
                return .none
            case .alertAction:
                return .none
            case .navigateToBack:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            }
        }
    }
}
