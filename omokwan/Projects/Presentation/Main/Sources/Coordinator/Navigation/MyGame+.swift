//
//  MyGame+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import MyGame
import MyGameAdd
import ComposableArchitecture

extension MainCoordinatorFeature {
    func myGameNavigation(_ state: inout State, _ action: MyGameFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToMyGameAddCategory:
            state.navigationPath.append(.myGameAddCategory(MyGameAddCategoryFeature.State()))
            return .none
        case .datePickerButtonTapped:
            return .none
        default:
            return .none
        }
    }
}
