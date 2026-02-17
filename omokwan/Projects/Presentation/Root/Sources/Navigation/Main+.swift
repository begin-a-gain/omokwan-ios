//
//  Main+.swift
//  Root
//
//  Created by jumy on 2/17/26.
//

import ComposableArchitecture
import Main
import Domain

extension RootFeature {
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
