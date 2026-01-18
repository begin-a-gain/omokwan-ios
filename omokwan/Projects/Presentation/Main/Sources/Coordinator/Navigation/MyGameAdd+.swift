//
//  MyGameAdd+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import MyGameAdd
import ComposableArchitecture

extension MainCoordinatorFeature {
    func myGameAddNavigation(_ state: inout State, _ action: MyGameAddFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            state.navigationPath.removeAll()
            return .none
        case .createRoomComplete(let title):
            state.navigationPath.removeAll()
            return .none
//            return .send(.myGameAction(.gameCreated(title)))
        default:
            return .none
        }
    }
}
