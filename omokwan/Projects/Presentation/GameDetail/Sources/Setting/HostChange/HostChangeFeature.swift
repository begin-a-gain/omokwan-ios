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
        public init() {}
        
        var tempUsers: [String] = ["빡빡이", "오목왕", "갹갹이", "오목왕갹갹이"]
        var isBottomButtonEnable: Bool = false
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case changeButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .navigateToBack:
                return .none
            case .changeButtonTapped:
                return .none
            }
        }
    }
}
