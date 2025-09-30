//
//  SignInNavigation.swift
//  SignIn
//
//  Created by 김동준 on 9/27/25
//

import ComposableArchitecture
import SignUp

extension SignInCoordinatorFeature {
    func signInNavigation(_ state: inout State, _ action: SignInFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToSignUp:
            state.navigationPath.append(.signUp(SignUpFeature.State()))
            return .none
        default:
            return .none
        }
    }
    
    func signUpNavigation(_ state: inout State, _ action: SignUpFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToBack:
            _ = state.navigationPath.popLast()
            return .none
        default:
            return .none
        }
    }
}
