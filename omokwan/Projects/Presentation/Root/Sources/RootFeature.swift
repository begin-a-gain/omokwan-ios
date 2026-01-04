//
//  RootFeature.swift
//  Root
//
//  Created by 김동준 on 7/19/25
//

import ComposableArchitecture
import SignIn
import Main
import Splash
import SignUp
import GameDetail
import Domain

@Reducer
public struct RootFeature {
    @Dependency(\.localUseCase) private var localUseCase

    public init() {}
    
    @ObservableState
    public struct State {
        public init() {}
        
        var root: RootPath.State = .splash(.init())
        var isToastPresented: Bool = false
        var toastMessage: String = ""
        @Shared(.userInfo) var userInfo = UserInfo()
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case root(RootPath.Action)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.root, action: \.root) {
            RootPath()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .root(.splash(let splashNavigationAction)):
                return splashNavigation(&state, splashNavigationAction)
            case .root(.signIn(.signInAction(let signInAction))):
                return signInNavigation(&state, signInAction)
            case .root(.signIn(.navigationPath(.element(id: _, action: SignInCoordinatorFeature.SignInPath.Action.signUp(let signUpAction))))):
                return signUpNavigation(&state, signUpAction)
            case .root(.signUpDone(let signUpDoneAction)):
                return signUpDoneNavigation(&state, signUpDoneAction)
            case .root(.main(.navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.gameDetail(let gameDetailAction))))):
                return handleGameDetailActionAtRoot(&state, gameDetailAction)
            case .root(.main(.mainAction(let mainAction))):
                return handleMainActionFromRoot(&state, mainAction)
            case .root(.main(.navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.hostChange(let hostChangeAction))))):
                return handleHostChangeActionAtRoot(&state, hostChangeAction)
            default:
                return .none
            }
        }
    }
}

private extension RootFeature {
    func handleGameDetailActionAtRoot(
        _ state: inout State,
        _ action: GameDetailFeature.Action
    ) -> Effect<Action> {
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

private extension RootFeature {
    func handleMainActionFromRoot(
        _ state: inout State,
        _ action: MainFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .alertLogoutButtonTapped:
            logout()
            clearUserInfo(&state)
            state.root = .signIn(.init())
            return .none
        case .nicknameUpdateCompleted:
            state.toastMessage = "닉네임이 변경 되었어요."
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
    
    func logout() {
        _ = localUseCase.setAccessToken("")
        localUseCase.setSignUpCompleted(false)
    }
    
    func clearUserInfo(_ state: inout State) {
        state.userInfo = UserInfo()
    }
}

private extension RootFeature {
    func handleHostChangeActionAtRoot(
        _ state: inout State,
        _ action: HostChangeFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .notifyHostChanged(let nickname):
            state.toastMessage = "대국장이 ‘\(nickname)’님으로 바뀌었어요."
            state.isToastPresented = true
            return .none
        default:
            return .none
        }
    }
}
