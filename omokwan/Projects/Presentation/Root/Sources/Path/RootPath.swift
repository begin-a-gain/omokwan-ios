//
//  RootPath.swift
//  Root
//
//  Created by 김동준 on 7/19/25
//

import ComposableArchitecture
import SignIn
import SignUp
import Main
import Splash

extension RootFeature {
    @Reducer
    public struct RootPath {
        @ObservableState
        public enum State: Equatable {
            case signIn(SignInFeature.State)
            case signUp(SignUpFeature.State)
            case signUpDone(SignUpDoneFeature.State)
            case main(MainCoordinatorFeature.State)
            case splash(SplashFeature.State)
        }

        public enum Action {
            case signIn(SignInFeature.Action)
            case signUp(SignUpFeature.Action)
            case signUpDone(SignUpDoneFeature.Action)
            case main(MainCoordinatorFeature.Action)
            case splash(SplashFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.signIn, action: \.signIn) {
                SignInFeature()
            }
            Scope(state: \.signUp, action: \.signUp) {
                SignUpFeature()
            }
            Scope(state: \.signUpDone, action: \.signUpDone) {
                SignUpDoneFeature()
            }
            Scope(state: \.main, action: \.main) {
                MainCoordinatorFeature()
            }
            Scope(state: \.splash, action: \.splash) {
                SplashFeature()
            }
        }
    }
}
