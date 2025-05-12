//
//  MainNavigation.swift
//  Main
//
//  Created by 김동준 on 12/1/24
//

import MyGame
import MyGameAdd
import MyGameParticipate
import ComposableArchitecture
import GameDetail

// MARK: MyGame Navigation
extension MainCoordinatorFeature {
    func myGameNavigation(_ state: inout State, _ action: MyGameFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToMyGameAddCategory:
            state.path.append(.myGameAddCategory(MyGameAddCategoryFeature.State()))
            return .none
        case .datePickerButtonTapped:
            return .none
        default:
            return .none
        }
    }
}

// MARK: MyGameAddCategory Navigation
extension MainCoordinatorFeature {
    func myGameAddCategoryNavigation(_ state: inout State, _ action: MyGameAddCategoryFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.path.popLast()
            return .none
        case .skipButtonTapped:
            state.path.append(.myGameAdd(MyGameAddFeature.State(selectedCategory: nil)))
            return .none
        case .nextButtonTapped(let category):
            state.path.append(.myGameAdd(MyGameAddFeature.State(selectedCategory: category)))
            return .none
        default:
            return .none
        }
    }
}

// MARK: MyGameAdd Navigation
extension MainCoordinatorFeature {
    func myGameAddNavigation(_ state: inout State, _ action: MyGameAddFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.path.popLast()
            return .none
        case .createRoomComplete(let title):
            state.path.removeAll()
            return .send(.myGameAction(.gameCreated(title)))
        default:
            return .none
        }
    }
}

// MARK: MyGameParticipate Navigation
extension MainCoordinatorFeature {
    func myGameParticipateNavigation(_ state: inout State, _ action: MyGameParticipateFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.path.popLast()
            return .none
        case .navigateToGameDetail(let roomInfo):
            state.path.append(.gameDetail(GameDetailFeature.State(roomInfo: roomInfo)))
            return .none
        default:
            return .none
        }
    }
}
