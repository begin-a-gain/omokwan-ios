//
//  GameCategorySelectFeature.swift
//  Base
//
//  Created by 김동준 on 5/26/25
//

import ComposableArchitecture
import Domain

public struct GameCategorySelectFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        public init(selectedCategory: GameCategory?) {
            self.selectedCategory = selectedCategory
        }
        
        var categories: [GameCategory] = GameCategory.allCases
        var selectedCategory: GameCategory?
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case categoryTapped(String)
        case selectButtonTapped(GameCategory)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .categoryTapped(let category):
                if let selectedCategory = state.selectedCategory, selectedCategory.rawValue == category {
                    state.selectedCategory = nil
                } else {
                    state.selectedCategory = state.categories.first { $0.rawValue == category }
                }
                
                return .none
            case .selectButtonTapped:
                return .none
            }
        }
    }
}
