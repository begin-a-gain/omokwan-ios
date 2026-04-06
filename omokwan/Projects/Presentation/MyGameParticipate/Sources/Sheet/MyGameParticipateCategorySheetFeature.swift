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
        public init(
            categories: [GameCategory],
            selectedCategoryList: [GameCategory]
        ) {
            self.categories = categories
            self.selectedCategoryTitles = Set(selectedCategoryList.map { $0.category })
        }
        
        var categories: [GameCategory]
        var selectedCategoryTitles: Set<String>
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case categoryTapped(String)
        case sheetConfirmButtonTapped
        case passSelectedCategories([GameCategory])
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
                let toPassValues: [GameCategory] = state.selectedCategoryTitles.compactMap { title in
                    state.categories.first(where: { $0.category == title })
                }
                return .send(.passSelectedCategories(toPassValues))
            case .passSelectedCategories:
                return .none
            }
        }
    }
}
