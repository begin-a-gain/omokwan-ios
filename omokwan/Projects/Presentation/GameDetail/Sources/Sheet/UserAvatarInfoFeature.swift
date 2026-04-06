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
    @Dependency(\.featureFlagUseCase) private var featureFlagUseCase

    public init() {}
    
    public struct State: Equatable {
        public init(
            detailUserInfo: DetailUserInfo,
            participantRole: ParticipantRole,
            userID: Int
        ) {
            self.detailUserInfo = detailUserInfo
            self.participantRole = participantRole
            self.userID = userID
        }
        
        let detailUserInfo: DetailUserInfo
        let participantRole: ParticipantRole
        let userID: Int
        var isShootStoneButtonHidden: Bool = false
    }
    
    public enum Action {
        case onAppear
        case shootStoneButtonTapped(String)
        case kickOutButtonTapped(String, Int)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isShootStoneButtonHidden = !featureFlagUseCase.isNotificationFlagEnabled()
                return .none
            case .shootStoneButtonTapped:
                return .none
            case .kickOutButtonTapped:
                return .none
            }
        }
    }
}
