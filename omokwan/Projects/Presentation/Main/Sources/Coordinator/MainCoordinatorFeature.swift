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
    
    @ObservableState
    public struct State {
        public init() {}

        public var navigationPath: StackState<MainPath.State> = .init()
        var mainState: MainFeature.State = .init()
    }

    public enum Action {
        case navigationPath(StackActionOf<MainPath>)
        case mainAction(MainFeature.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.mainState, action: \.mainAction) {
            MainFeature()
        }

        Reduce { state, action in
            switch action {
            case .navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGame(let myGameAction))):
                return myGameNavigation(&state, myGameAction)
            case .navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGameAddCategory(let myGameAddCategoryAction))):
                return myGameAddCategoryNavigation(&state, myGameAddCategoryAction)
            case .navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGameAdd(let myGameAddAction))):
                return myGameAddNavigation(&state, myGameAddAction)
            case .navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.myGameParticipate(let myGameParticipateAction))):
                return myGameParticipateNavigation(&state, myGameParticipateAction)
            case .navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.gameDetail(let gameDetailAction))):
                return gameDetailNavigation(&state, gameDetailAction)
            case .navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.gameDetailSetting(let gameDetailSettingAction))):
                return gameDetailSettingNavigation(&state, gameDetailSettingAction)
            case .navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.hostChange(let hostChangeAction))):
                return hostChangeNavigation(&state, hostChangeAction)
            case .navigationPath:
                return .none
            case .mainAction(let mainAction):
                switch mainAction {
                case .navigateToMyGameAddCategory:
                    state.navigationPath.append(.myGameAddCategory(.init()))
                    return .none
                case .navigateToMyGameParticipate:
                    state.navigationPath.append(.myGameParticipate(.init()))
                    return .none
                case let .navigateToGameDetail(id, title):
                    state.navigationPath.append(
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
        .forEach(\.navigationPath, action: \.navigationPath)
    }
}
