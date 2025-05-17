//
//  GameDetailSettingFeature.swift
//  GameDetail
//
//  Created by 김동준 on 5/17/25
//

import ComposableArchitecture
import Domain
import Foundation
import Util

@Reducer
public struct GameDetailSettingFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
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
