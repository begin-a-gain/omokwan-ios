//
//  MyPageFeature.swift
//  MyPage
//
//  Created by 김동준 on 11/2/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct MyPageFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        @Shared(.userInfo) var userInfo = UserInfo()
    }

    public enum Action {
        case onAppear
        case nicknameTapped
        case logoutButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .nicknameTapped:
                // TODO: 닉네임 편집
                return .none
            case .logoutButtonTapped:
                return .none
            }
        }
    }
}
