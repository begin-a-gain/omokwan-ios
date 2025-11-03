//
//  EditNicknameFeature.swift
//  MyPage
//
//  Created by 김동준 on 11/3/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct EditNicknameFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        @Shared(.userInfo) var userInfo = UserInfo()
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
