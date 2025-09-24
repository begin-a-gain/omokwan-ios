//
//  HostChangeFeature.swift
//  GameDetail
//
//  Created by 김동준 on 9/23/25
//

import ComposableArchitecture
import Domain

@Reducer
public struct HostChangeFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {
        }
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
