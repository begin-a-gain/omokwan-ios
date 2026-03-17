//
//  InvitationFeature.swift
//  GameDetail
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture
import Domain

@Reducer
public struct InvitationFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init(
            gameID: Int,
            gameUserInfos: [GameUserInfo],
            maxParticipants: Int
        ) {
            self.gameID = gameID
            self.gameUserInfos = gameUserInfos
            self.maxParticipants = maxParticipants
        }
        
        let gameID: Int
        let gameUserInfos: [GameUserInfo]
        let maxParticipants: Int
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .navigateToBack:
                return .none
            }
        }
    }
}
