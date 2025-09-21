//
//  UserAvatarInfoFeature.swift
//  GameDetail
//
//  Created by 김동준 on 9/15/25
//

import ComposableArchitecture
import Domain

@Reducer
public struct UserAvatarInfoFeature {
    public init() {}
    
    public struct State: Equatable {
        public init(detailUserInfo: DetailUserInfo, participantRole: ParticipantRole) {
            self.detailUserInfo = detailUserInfo
            self.participantRole = participantRole
        }
        
        let detailUserInfo: DetailUserInfo
        let participantRole: ParticipantRole
    }
    
    public enum Action {
        case onAppear
        case shootStoneButtonTapped(String)
        case kickOutButtonTapped(String)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .shootStoneButtonTapped:
                return .none
            case .kickOutButtonTapped:
                return .none
            }
        }
    }
}
