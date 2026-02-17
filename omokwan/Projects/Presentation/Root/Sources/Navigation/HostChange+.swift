//
//  HostChange+.swift
//  Root
//
//  Created by jumy on 2/17/26.
//

import ComposableArchitecture
import GameDetail

extension RootFeature {
    func handleHostChangeActionAtRoot(
        _ state: inout State,
        _ action: HostChangeFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .notifyHostChanged(let nickname):
            state.toastMessage = "대국장이 ‘\(nickname)’님으로 바뀌었어요."
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
}
