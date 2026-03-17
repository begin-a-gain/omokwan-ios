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
    @Dependency(\.localUseCase) var localUseCase

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
            case .root(.main(.navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.gameDetailSetting(let gameDetailSettingAction))))):
                return handleGameSettingActionAtRoot(&state, gameDetailSettingAction)
            case .root(.main(.navigationPath(.element(id: _, action: MainCoordinatorFeature.MainPath.Action.invitation(let invitationAction))))):
                return handleInvitationActionAtRoot(&state, invitationAction)
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
