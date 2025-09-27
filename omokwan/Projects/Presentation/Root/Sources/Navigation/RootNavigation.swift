//
//  RootNavigation.swift
//  Root
//
//  Created by 김동준 on 9/27/25
//

import ComposableArchitecture
import Splash
import SignUp
import SignIn

extension RootFeature {
    func splashNavigation(_ state: inout State, _ action: SplashFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToSignIn:
            state.root = .signIn(.init())
            return .none
        case .navigateToMain:
            state.root = .main(.init())
            return .none
        default:
            return .none
        }
    }
    
    func signInNavigation(_ state: inout State, _ action: SignInFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToMain:
            state.root = .main(.init())
            return .none
        default:
            return .none
        }
    }
    
    func signUpNavigation(_ state: inout State, _ action: SignUpFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToSignUpDone:
            state.root = .signUpDone(.init())
            return .none
        default:
            return .none
        }
    }
    
    func signUpDoneNavigation(_ state: inout State, _ action: SignUpDoneFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToMain:
            state.root = .main(.init())
            return .none
        case .signInAgain:
            state.root = .signIn(.init())
            return .none
        default:
            return .none
        }
    }
}
