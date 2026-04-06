//
//  SignIn+.swift
//  Root
//
//  Created by 김동준 on 1/14/26
//

import SignIn
import ComposableArchitecture

extension RootFeature {
    func signInNavigation(_ state: inout State, _ action: SignInFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToMain:
            state.root = .main(.init())
            return .none
        default:
            return .none
        }
    }
}
