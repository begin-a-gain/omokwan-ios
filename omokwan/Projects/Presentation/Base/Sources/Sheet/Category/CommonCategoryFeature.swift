//
//  CommonCategoryFeature.swift
//  Base
//
//  Created by 김동준 on 9/23/25
//

import ComposableArchitecture
import Domain

@Reducer
public struct CommonCategoryFeature {
    public init() {}
    
    public struct State: Equatable {
        public init(
            categories: [GameCategory],
            selectedCategory: GameCategory?
        ) {
            self.categories = categories
            self.selectedCategory = selectedCategory
        }
        
        var categories: [GameCategory]
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
                if let selectedCategory = state.selectedCategory, selectedCategory.category == category {
                    state.selectedCategory = nil
                } else {
                    state.selectedCategory = state.categories.first { $0.category == category }
                }
                
                return .none
            case .selectButtonTapped:
                return .none
            }
        }
    }
}
