//
//  MyGameSheetFeature.swift
//  MyGame
//
//  Created by 김동준 on 12/15/24
//

import ComposableArchitecture
import Foundation

public struct MyGameSheetFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        public init(selectedDate: Date) {
            self.selectedDate = selectedDate
        }
        
        @BindingState var selectedDate: Date
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectButtonTapped
        case dismissSheetWithData(Date)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .selectButtonTapped:
                return .send(.dismissSheetWithData(state.selectedDate))
            case .dismissSheetWithData:
                return .none
            }
        }
    }
}
