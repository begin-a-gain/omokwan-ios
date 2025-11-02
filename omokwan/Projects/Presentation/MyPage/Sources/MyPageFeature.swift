//
//  MyPageFeature.swift
//  MyPage
//
//  Created by 김동준 on 11/2/25
//

import ComposableArchitecture

@Reducer
public struct MyPageFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
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
