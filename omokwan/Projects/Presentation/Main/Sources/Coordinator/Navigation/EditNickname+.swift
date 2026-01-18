//
//  EditNickname+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import MyPage
import ComposableArchitecture

extension MainCoordinatorFeature {
    func editNicknameNavigation(_ state: inout State, _ action: EditNicknameFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .nicknameUpdateCompleted:
            _ = state.navigationPath.popLast()
            return .send(.mainAction(.nicknameUpdateCompleted))
        default:
            return .none
        }
    }
}
