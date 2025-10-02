//
//  MainFeature.swift
//  Main
//
//  Created by 김동준 on 7/22/25
//

import ComposableArchitecture
import MyGame
import MyGameAdd
import Base
import Domain

@Reducer
public struct MainFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()

        var isMainLoading = false
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
        case navigateToGameDetail(Int, String, String)
        case myGameAction(MyGameFeature.Action)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
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
            case .navigateToGameDetail:
                return .none
            case .addGameButtonTapped:
                state.mainSheet = .init()
                return .none
            case .noAction:
                return .none
            case .myGameAction(let myGameAction):
                switch myGameAction {
                case .setLoading(let value):
                    state.isMainLoading = value
                    return .none
                case .passError(let networkError):
                    return .send(.showAlert(.error(networkError)))
                case let .navigateToGameDetail(id, title, selectedDateString):
                    return .send(.navigateToGameDetail(id, title, selectedDateString))
                default:
                    return .none
                }
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isMainLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            }
        }
        .ifLet(\.$mainSheet, action: \.mainSheet) {
            MainSheetFeature()
        }
        
        Scope(state: \.myGameState, action: \.myGameAction) {
            MyGameFeature()
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
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
