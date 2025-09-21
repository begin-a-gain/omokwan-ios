//
//  RootFeature.swift
//  Root
//
//  Created by 김동준 on 7/19/25
//

import ComposableArchitecture
import SignIn
import SignUp
import Main
import Splash
import GameDetail

@Reducer
public struct RootFeature {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        var path: RootPath.State = .splash(.init())
        var navigationPath: StackState<RootPath.State> = .init()
        
        @BindingState var isToastPresented: Bool = false
        var toastMessage: String = ""
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case path(RootPath.Action)
        case navigatePathAction(StackAction<RootPath.State, RootPath.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.path, action: \.path) {
            RootPath()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .path(.signIn(let signInAction)):
                return signInNavigation(&state, signInAction)
            case .path(.signUp(let signUpAction)):
                return signUpNavigation(&state, signUpAction)
            case .path(.signUpDone(let signUpDoneAction)):
                return signUpDoneNavigation(&state, signUpDoneAction)
            case .navigatePathAction(.element(id: _, action: RootFeature.RootPath.Action.signUp(let signUpNavigationAction))):
                return signUpNavigation(&state, signUpNavigationAction)
            case .path(.main(let mainCoordinatorAction)):
                switch mainCoordinatorAction {
                case .mainAction(let mainAction):
                    return mainNavigation(&state, mainAction)
                case .path(let pathAction):
                    switch pathAction {
                    case .element(id: _, action: MainCoordinatorFeature.MainPath.Action.gameDetail(let gameDetailAction)):
                        return handleGameDetailAction(&state, gameDetailAction)
                    default:
                        return .none
                    }
                }
            case .path(.splash(let splashNavigationAction)):
                return splashNavigation(&state, splashNavigationAction)
            default:
                return .none
            }
        }
        .forEach(\.navigationPath, action: \.navigatePathAction) {
            RootPath()
        }
    }
}

// SignIn
private extension RootFeature {
    private func signInNavigation(_ state: inout State, _ action: SignInFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToSignUp:
            state.navigationPath.append(.signUp(SignUpFeature.State()))
            return .none
        case .navigateToMain:
            state.path = .main(.init())
            return .none
        default:
            return .none
        }
    }
}

// SignUp
private extension RootFeature {
    private func signUpNavigation(_ state: inout State, _ action: SignUpFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        case .navigateToSignUpDone:
            state.navigationPath = .init()
            state.path = .signUpDone(.init())
            return .none
        default:
            return .none
        }
    }
}

// SignUpDone
private extension RootFeature {
    private func signUpDoneNavigation(_ state: inout State, _ action: SignUpDoneFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToMain:
            state.path = .main(.init())
            return .none
        case .signInAgain:
            state.path = .signIn(.init())
            return .none
        default:
            return .none
        }
    }
}

// mainAction
private extension RootFeature {
    private func mainNavigation(_ state: inout State, _ action: MainFeature.Action) -> Effect<Action> {
        switch action {
//             TODO: SignOut Grab, clear shared user
//        case .signOutCaseTemp:
//            state.navigationPath = .init()
//            state.path = .signIn(.init())
//            return .none
        default:
            return .none
        }
    }
}

// Splash
private extension RootFeature {
    func splashNavigation(_ state: inout State, _ action: SplashFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToSignIn:
            state.path = .signIn(.init())
            return .none
        case .navigateToMain:
            state.path = .main(.init())
            return .none
        default:
            return .none
        }
    }
}

private extension RootFeature {
    func handleGameDetailAction(_ state: inout State, _ action: GameDetailFeature.Action) -> Effect<Action> {
        switch action {
        case .shootStoneSuccess(let nickname):
            state.toastMessage = "팅, ‘\(nickname)’님에게 오목알을 튕겼어요."
            state.isToastPresented = true
            return .none
        case .shootStoneFailed:
            // TODO: 실패 케이스 논의 후 적용 필요
            state.toastMessage = "오목알 튕기기 실패!"
            state.isToastPresented = true
            return .none
        case .kickOutAlertButtonTapped(let nickname):
            state.toastMessage = "‘\(nickname)’님을 내보냈어요."
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
}
