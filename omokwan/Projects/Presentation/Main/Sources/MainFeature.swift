//
//  MainFeature.swift
//  Main
//
//  Created by 김동준 on 7/22/25
//

import ComposableArchitecture
import MyGame
import MyGameAdd

@Reducer
public struct MainFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}

        @BindingState var selectedTab: MainBottomTabItem = .myGame
        var myGameState: MyGameFeature.State = .init()

        @PresentationState var mainSheet: MainSheetFeature.State?
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectTab(MainBottomTabItem)
        case mainSheet(PresentationAction<MainSheetFeature.Action>)
        case addGameButtonTapped
        case noAction
        case navigateToMyGameAddCategory
        case navigateToMyGameParticipate
        case myGameAction(MyGameFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .selectTab(let item):
                state.selectedTab = item
                return .none
            case .mainSheet(let presentationAction):
                switch presentationAction {
                case .presented(let sheetAction):
                    switch sheetAction {
                    case .navigateToMyGameAddCategory:
                        state.mainSheet = nil
                        return .concatenate([
                            .run { send in
                                await send(waitFewSeconds())
                            },
                            .send(.navigateToMyGameAddCategory)
                        ])
                    case .navigateToMyGameParticipate:
                        state.mainSheet = nil
                        return .concatenate([
                            .run { send in
                                await send(waitFewSeconds())
                            },
                            .send(.navigateToMyGameParticipate)
                        ])
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case .navigateToMyGameAddCategory:
                return .none
            case .navigateToMyGameParticipate:
                return .none
            case .addGameButtonTapped:
                state.mainSheet = .init()
                return .none
            case .noAction:
                return .none
            case .myGameAction:
                return .none
            }
        }
        .ifLet(\.$mainSheet, action: \.mainSheet) {
            MainSheetFeature()
        }
        
        Scope(state: \.myGameState, action: \.myGameAction) {
            MyGameFeature()
        }
    }
}

private extension MainFeature {
    func waitFewSeconds() async -> Action {
        do {
            try await Task.sleep(for: .seconds(0.1))
            return .noAction
        } catch {
            return .noAction
        }
    }
}
