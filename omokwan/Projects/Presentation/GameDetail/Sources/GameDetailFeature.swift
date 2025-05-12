//
//  GameDetailFeature.swift
//  GameDetail
//
//  Created by 김동준 on 5/12/25
//

import ComposableArchitecture
import Domain

@Reducer
public struct GameDetailFeature {
    public init() {}
    
    public struct State: Equatable {
        public init(roomInfo: GameRoomInformation) {
            self.roomInfo = roomInfo
        }
        
        var roomInfo: GameRoomInformation
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
