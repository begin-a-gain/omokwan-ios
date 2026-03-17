//
//  InvitationFeature.swift
//  GameDetail
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct InvitationFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        
        public init(
            gameID: Int,
            gameUserInfos: [GameUserInfo],
            maxParticipants: Int
        ) {
            self.gameID = gameID
            self.gameUserInfos = gameUserInfos
            self.maxParticipants = maxParticipants
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false

        let gameID: Int
        let gameUserInfos: [GameUserInfo]
        let maxParticipants: Int
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
        
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
    }
}
