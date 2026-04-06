//
//  Notification+.swift
//  Main
//
//  Created by jumy on 3/14/26.
//

import Notification
import ComposableArchitecture
import GameDetail

extension MainCoordinatorFeature {
    func notificationNavigation(_ state: inout State, _ action: NotificationFeature.Action) -> Effect<Action> {
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
