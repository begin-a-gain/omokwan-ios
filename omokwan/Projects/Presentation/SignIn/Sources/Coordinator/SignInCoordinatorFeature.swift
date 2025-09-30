//
//  SignInCoordinatorFeature.swift
//  SignIn
//
//  Created by 김동준 on 9/25/25
//

import ComposableArchitecture
import SignUp

@Reducer
public struct SignInCoordinatorFeature {
    public init() {}
    
    @ObservableState
    public struct State {
        public init() {}
        
        public var navigationPath: StackState<SignInPath.State> = .init()
        var signInState: SignInFeature.State = .init()
    }
    
    public enum Action {
        case navigationPath(StackActionOf<SignInPath>)
        case signInAction(SignInFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.signInState, action: \.signInAction) {
            SignInFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .signInAction(let signInAction):
                return signInNavigation(&state, signInAction)
            case .navigationPath(.element(id: _, action: SignInCoordinatorFeature.SignInPath.Action.signUp(let signUpAction))):
                return signUpNavigation(&state, signUpAction)
            default:
                return .none
            }
        }
        .forEach(\.navigationPath, action: \.navigationPath)
    }
}
