//
//  GameDetail+.swift
//  Root
//
//  Created by jumy on 2/17/26.
//

import ComposableArchitecture
import GameDetail

extension RootFeature {
    func handleGameDetailActionAtRoot(
        _ state: inout State,
        _ action: GameDetailFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .shootStoneSuccess(let nickname):
            state.toastMessage = "팅, ‘\(nickname)’님에게 오목알을 튕겼어요."
            state.isToastPresented = true
            return .none
        case .shootStoneFailed:
            // TODO: 실패 케이스 논의 후 적용 필요
            state.toastMessage = "오목알 튕기기 실패!"
            state.isToastPresented = true
            return .none
        case let .userKicked(nickname, _):
            state.toastMessage = "‘\(nickname)’님을 내보냈어요."
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
}
