//
//  HostChange+.swift
//  Main
//
//  Created by 김동준 on 1/14/26
//

import GameDetail
import ComposableArchitecture

extension MainCoordinatorFeature {
    func hostChangeNavigation(_ state: inout State, _ action: HostChangeFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .hostChangedWithData(let infos):
            guard let targetID = state.navigationPath.ids.dropLast().last else { return .none }
            _ = state.navigationPath.popLast()
            
            return .send(.navigationPath(.element(id: targetID, action: .gameDetailSetting(.updateGameUserInfos(infos)))))
        default:
            return .none
        }
    }
}
