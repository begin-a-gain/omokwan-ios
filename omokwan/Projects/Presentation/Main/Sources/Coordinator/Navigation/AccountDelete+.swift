//
//  AccountDelete+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import MyPage
import ComposableArchitecture

extension MainCoordinatorFeature {
    func accountDeleteNavigation(_ state: inout State, _ action: AccountDeleteFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .deleteAccountAlertButtonTapped:
            return .send(.mainAction(.alertLogoutButtonTapped))
        default:
            return .none
        }
    }
}
