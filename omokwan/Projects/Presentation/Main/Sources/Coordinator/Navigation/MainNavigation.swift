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
        case .skipButtonTapped(let categories):
            state.path.append(
                .myGameAdd(
                    MyGameAddFeature.State(
                        categories: categories,
                        selectedCategory: nil
                    )
                )
            )
            return .none
        case let .nextButtonTapped(categories, selectedCategory):
            state.path.append(
                .myGameAdd(
                    MyGameAddFeature.State(
                        categories: categories,
                        selectedCategory: selectedCategory
                    )
                )
            )
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
            state.path.removeAll()
            return .none
        case .createRoomComplete(let title):
            state.path.removeAll()
            return .none
//            return .send(.myGameAction(.gameCreated(title)))
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


// MARK: GameDetail Navigation
extension MainCoordinatorFeature {
    func gameDetailNavigation(_ state: inout State, _ action: GameDetailFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.path.popLast()
            return .none
        default:
            return .none
        }
    }
}
