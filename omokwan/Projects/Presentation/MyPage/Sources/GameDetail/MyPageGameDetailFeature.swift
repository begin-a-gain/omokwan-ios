//
//  MyPageGameDetailFeature.swift
//  MyPage
//
//  Created by 김동준 on 1/14/26
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct MyPageGameDetailFeature {
    public init() {}
    
    public struct State: Equatable {
        public init(type: MyPageGameDetailType) {
            self.type = type
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        var isLoading: Bool = false
        let type: MyPageGameDetailType
    }

    public enum Action {
        case onAppear
        case navigateToBack
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .navigateToBack:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            }
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
    }
}
