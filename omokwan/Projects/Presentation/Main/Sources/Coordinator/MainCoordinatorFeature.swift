//
//  MainCoordinatorFeature.swift
//  Main
//
//  Created by 김동준 on 10/3/24
//

import Base
import ComposableArchitecture
import GameDetail

@Reducer
public struct MainCoordinatorFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}

        public var path: StackState<MainPath.State> = .init()
        var mainState: MainFeature.State = .init()
    }

    public enum Action {
        case path(StackAction<MainPath.State, MainPath.Action>)
        case mainAction(MainFeature.Action)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGame(let myGameAction))):
                return myGameNavigation(&state, myGameAction)
            case .path(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGameAddCategory(let myGameAddCategoryAction))):
                return myGameAddCategoryNavigation(&state, myGameAddCategoryAction)
            case .path(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGameAdd(let myGameAddAction))):
                return myGameAddNavigation(&state, myGameAddAction)
            case .path(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGameParticipate(let myGameParticipateAction))):
                return myGameParticipateNavigation(&state, myGameParticipateAction)
            case .path(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.gameDetail(let gameDetailAction))):
                return gameDetailNavigation(&state, gameDetailAction)
            case .path(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.gameDetailSetting(let gameDetailSettingAction))):
                return gameDetailSettingNavigation(&state, gameDetailSettingAction)
            case .path:
                return .none
            case .mainAction(let mainAction):
                switch mainAction {
                case .navigateToMyGameAddCategory:
                    state.path.append(.myGameAddCategory(.init()))
                    return .none
                case .navigateToMyGameParticipate:
                    state.path.append(.myGameParticipate(.init()))
                    return .none
                case let .navigateToGameDetail(id, title):
                    state.path.append(
                        .gameDetail(
                            GameDetailFeature.State(
                                gameID: id,
                                gameTitle: title
                            )
                        )
                    )
                    return .none
                default:
                    return .none
                }
            }
        }
        .forEach(\.path, action: \.path) {
            MainPath()
        }
        
        Scope(state: \.mainState, action: \.mainAction) {
            MainFeature()
        }
    }
}
