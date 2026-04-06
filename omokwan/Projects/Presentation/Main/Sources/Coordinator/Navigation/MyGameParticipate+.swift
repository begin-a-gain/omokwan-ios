//
//  MyGameParticipate+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import MyGameParticipate
import ComposableArchitecture
import GameDetail

extension MainCoordinatorFeature {
    func myGameParticipateNavigation(_ state: inout State, _ action: MyGameParticipateFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case let .navigateToGameDetail(id, title, selectedDateString):
            state.navigationPath.append(
                .gameDetail(
                    GameDetailFeature.State(
                        gameID: id,
                        gameTitle: title,
                        selectedDateString: selectedDateString
                    )
                )
            )
            return .none
        default:
            return .none
        }
    }
}
