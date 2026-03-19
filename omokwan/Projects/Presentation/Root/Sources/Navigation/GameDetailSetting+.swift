//
//  GameDetailSetting+.swift
//  Root
//
//  Created by jumy on 2/17/26.
//

import ComposableArchitecture
import GameDetail

extension RootFeature {
    func handleGameSettingActionAtRoot(
        _ state: inout State,
        _ action: GameDetailSettingFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .sendCopyToast(let message), .sendSaveToast(let message), .sendExitToast(let message):
            state.toastMessage = message
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
}
