//
//  RootPath.swift
//  Root
//
//  Created by 김동준 on 7/19/25
//

import ComposableArchitecture
import SignIn
import Main
import Splash
import SignUp

extension RootFeature {
    @Reducer
    public struct RootPath {
        @ObservableState
        public enum State {
            case signIn(SignInCoordinatorFeature.State)
            case main(MainCoordinatorFeature.State)
            case splash(SplashFeature.State)
            case signUpDone(SignUpDoneFeature.State)
        }

        public enum Action {
            case signIn(SignInCoordinatorFeature.Action)
            case main(MainCoordinatorFeature.Action)
            case splash(SplashFeature.Action)
            case signUpDone(SignUpDoneFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.signIn, action: \.signIn) {
                SignInCoordinatorFeature()
            }
            Scope(state: \.main, action: \.main) {
                MainCoordinatorFeature()
            }
            Scope(state: \.splash, action: \.splash) {
                SplashFeature()
            }
            Scope(state: \.signUpDone, action: \.signUpDone) {
                SignUpDoneFeature()
            }
        }
    }
}
