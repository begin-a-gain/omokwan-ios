//
//  Invitation+.swift
//  Main
//
//  Created by jumy on 3/14/26.
//

import GameDetail
import ComposableArchitecture

extension MainCoordinatorFeature {
    func invitationNavigation(_ state: inout State, _ action: InvitationFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .sendToast:
            return .none
        default:
            return .none
        }
    }
}
