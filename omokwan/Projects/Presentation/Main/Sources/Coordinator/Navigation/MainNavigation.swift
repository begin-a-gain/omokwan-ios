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
import MyPage

extension MainCoordinatorFeature {
    func myGameNavigation(_ state: inout State, _ action: MyGameFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToMyGameAddCategory:
            state.navigationPath.append(.myGameAddCategory(MyGameAddCategoryFeature.State()))
            return .none
        case .datePickerButtonTapped:
            return .none
        default:
            return .none
        }
    }
}

extension MainCoordinatorFeature {
    func myGameAddCategoryNavigation(_ state: inout State, _ action: MyGameAddCategoryFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .skipButtonTapped(let categories):
            state.navigationPath.append(
                .myGameAdd(
                    MyGameAddFeature.State(
                        categories: categories,
                        selectedCategory: nil
                    )
                )
            )
            return .none
        case let .nextButtonTapped(categories, selectedCategory):
            state.navigationPath.append(
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


extension MainCoordinatorFeature {
    func gameDetailNavigation(_ state: inout State, _ action: GameDetailFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case let .navigateToSetting(gameID, gameUserInfos):
            state.navigationPath.append(
                .gameDetailSetting(
                    .init(
                        gameID: gameID,
                        gameUserInfos: gameUserInfos
                    )
                )
            )
            return .none
        default:
            return .none
        }
    }
}

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
        default:
            return .none
        }
    }
}

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

extension MainCoordinatorFeature {
    func editNicknameNavigation(_ state: inout State, _ action: EditNicknameFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .nicknameUpdateCompleted:
            _ = state.navigationPath.popLast()
            return .send(.mainAction(.nicknameUpdateCompleted))
        default:
            return .none
        }
    }
}

extension MainCoordinatorFeature {
    func accountDeleteNavigation(_ state: inout State, _ action: AccountDeleteFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .deleteAccountAlertButtonTapped:
            return .send(.mainAction(.alertLogoutButtonTapped))
        default:
            return .none
        }
    }
}

extension MainCoordinatorFeature {
    func myPageGameDetailNavigation(_ state: inout State, _ action: MyPageGameDetailFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        default:
            return .none
        }
    }
}
