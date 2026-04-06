//
//  MyGameAddCategory+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import MyGameAdd
import ComposableArchitecture

extension MainCoordinatorFeature {
    func myGameAddCategoryNavigation(_ state: inout State, _ action: MyGameAddCategoryFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .skipButtonTapped(let categories):
            state.navigationPath.append(
                .myGameAdd(
                    MyGameAddFeature.State(
                        categories: categories,
                        selectedCategory: nil
                    )
                )
            )
            return .none
        case let .nextButtonTapped(categories, selectedCategory):
            state.navigationPath.append(
                .myGameAdd(
                    MyGameAddFeature.State(
                        categories: categories,
                        selectedCategory: selectedCategory
                    )
                )
            )
            return .none
        default:
            return .none
        }
    }
}
