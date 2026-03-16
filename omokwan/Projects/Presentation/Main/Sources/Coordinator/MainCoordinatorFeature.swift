//
//  MainCoordinatorFeature.swift
//  Main
//
//  Created by 김동준 on 10/3/24
//

import Base
import ComposableArchitecture
import GameDetail
import Domain
import Notification

@Reducer
public struct MainCoordinatorFeature {
    private typealias PathAction = MainCoordinatorFeature.MainPath.Action
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
            case .navigationPath(.element(id: _, action: PathAction.myGame(let myGameAction))):
                return myGameNavigation(&state, myGameAction)
            case .navigationPath(.element(id: _, action: PathAction.myGameAddCategory(let myGameAddCategoryAction))):
                return myGameAddCategoryNavigation(&state, myGameAddCategoryAction)
            case .navigationPath(.element(id: _, action: PathAction.myGameAdd(let myGameAddAction))):
                return myGameAddNavigation(&state, myGameAddAction)
            case .navigationPath(.element(id: _, action: PathAction.myGameParticipate(let myGameParticipateAction))):
                return myGameParticipateNavigation(&state, myGameParticipateAction)
            case .navigationPath(.element(id: _, action: PathAction.gameDetail(let gameDetailAction))):
                return gameDetailNavigation(&state, gameDetailAction)
            case .navigationPath(.element(id: _, action: PathAction.gameDetailSetting(let gameDetailSettingAction))):
                return gameDetailSettingNavigation(&state, gameDetailSettingAction)
            case .navigationPath(.element(id: _, action: PathAction.hostChange(let hostChangeAction))):
                return hostChangeNavigation(&state, hostChangeAction)
            case .navigationPath(.element(id: _, action: PathAction.editNickname(let editNicknameAction))):
                return editNicknameNavigation(&state, editNicknameAction)
            case .navigationPath(.element(id: _, action: PathAction.accountDelete(let accountDeleteAction))):
                return accountDeleteNavigation(&state, accountDeleteAction)
            case .navigationPath(.element(id: _, action: PathAction.myPageGameDetail(let myPageGameDetailAction))):
                return myPageGameDetailNavigation(&state, myPageGameDetailAction)
            case .navigationPath(.element(id: _, action: PathAction.notification(let notificationAction))):
                return notificationNavigation(&state, notificationAction)
            case .navigationPath:
                return .none
            case .mainAction(let mainAction):
                return handleMainAction(&state, mainAction)
            }
        }
        .forEach(\.navigationPath, action: \.navigationPath)
    }
}

private extension MainCoordinatorFeature {
    func handleMainAction(_ state: inout State, _ mainAction: MainFeature.Action) -> Effect<Action> {
        switch mainAction {
        case .navigateToMyGameAddCategory:
            state.navigationPath.append(.myGameAddCategory(.init()))
            return .none
        case .navigateToMyGameParticipate:
            state.navigationPath.append(.myGameParticipate(.init()))
            return .none
        case .navigateToNotification:
            state.navigationPath.append(.notification(.init()))
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
        case .navigateToEditNickname:
            state.navigationPath.append(.editNickname(.init()))
            return .none
        case .navigateToAccountDelete:
            state.navigationPath.append(.accountDelete(.init()))
            return .none
        case let .navigateToMyPageGameDetail(type, info):
            let gameInfo: [MyPageGameDetailModel] = switch type {
            case .ongoing:
                info.inProgressGames
            case .completed:
                info.completedGames
            }
            
            state.navigationPath.append(
                .myPageGameDetail(.init(type: type, info: gameInfo))
            )
            return .none
        default:
            return .none
        }
    }
}
