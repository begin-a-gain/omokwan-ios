//
//  MyGameParticipateCategorySheetFeature.swift
//  MyGameParticipate
//
//  Created by 김동준 on 2/2/25
//

import ComposableArchitecture
import Domain

public struct MyGameParticipateCategorySheetFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        public init(selectedCategoryTitles: [String]) {
            self.selectedCategoryTitles = Set(selectedCategoryTitles)
        }
        
        var categories: [GameCategory] = []
        var selectedCategoryTitles: Set<String>
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case categoryTapped(String)
        case sheetConfirmButtonTapped
        case passSelectedCategories([String])
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .categoryTapped(let title):
                if state.selectedCategoryTitles.contains(title) {
                    state.selectedCategoryTitles.remove(title)
                } else {
                    state.selectedCategoryTitles.insert(title)
                }
                return .none
            case .sheetConfirmButtonTapped:
                let toPassValues: [String] = Array(state.selectedCategoryTitles)
                return .send(.passSelectedCategories(toPassValues))
            case .passSelectedCategories:
                return .none
            }
        }
    }
}
