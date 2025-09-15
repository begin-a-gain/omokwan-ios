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
        public init(detailUserInfo: DetailUserInfo) {
            self.detailUserInfo = detailUserInfo
        }
        
        private let detailUserInfo: DetailUserInfo
    }
    
    public enum Action {
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
