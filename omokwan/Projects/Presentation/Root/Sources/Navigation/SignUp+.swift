//
//  SignUp+.swift
//  Root
//
//  Created by 김동준 on 1/14/26
//

import SignUp
import ComposableArchitecture

extension RootFeature {
    func signUpNavigation(_ state: inout State, _ action: SignUpFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToSignUpDone:
            state.root = .signUpDone(.init())
            return .none
        default:
            return .none
        }
    }
}
