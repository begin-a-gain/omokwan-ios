//
//  SignUpDone+.swift
//  Root
//
//  Created by 김동준 on 1/14/26
//

import SignUp
import ComposableArchitecture

extension RootFeature {
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
