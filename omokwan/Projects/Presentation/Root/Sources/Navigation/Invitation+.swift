//
//  Invitation+.swift
//  Root
//
//  Created by Codex on 3/14/26.
//

import ComposableArchitecture
import GameDetail

extension RootFeature {
    func handleInvitationActionAtRoot(
        _ state: inout State,
        _ action: InvitationFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .sendToast(let message):
            state.toastMessage = message
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
}
