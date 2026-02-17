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
        case .sendToast(let title):
            state.toastMessage = "‘\(title)’에서 나왔어요. 다음에 다시 도전해 보세요!"
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
}
