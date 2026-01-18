//
//  Splash+.swift
//  Root
//
//  Created by 김동준 on 1/14/26
//

import Splash
import ComposableArchitecture

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
}
