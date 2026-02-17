//
//  GameDetailSetting+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import GameDetail
import ComposableArchitecture

extension MainCoordinatorFeature {
    func gameDetailSettingNavigation(_ state: inout State, _ action: GameDetailSettingFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case let .navigateToHostChange(gameID, gameUserInfos):
            state.navigationPath.append(
                .hostChange(
                    .init(
                        gameID: gameID,
                        gameUserInfos: gameUserInfos
                    )
                )
            )
            return .none
        case .sendToast:
            state.navigationPath.removeAll()
            return .none
        default:
            return .none
        }
    }
}
