//
//  RootCoordinatorFeature.swift
//  Root
//
//  Created by 김동준 on 11/20/24
//

import ComposableArchitecture
import SignIn
import SignUp
import Main

public struct RootCoordinatorFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        @Shared(.auth) var isAuth: Bool = false
        
        var path: StackState<RootPath.State> = .init()
    }
    
    public enum Action {
        case path(StackAction<RootPath.State, RootPath.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: RootCoordinatorFeature.RootPath.Action.signIn(let signInAction))):
                return signInNavigation(&state, signInAction)
            case .path(.element(id: _, action: RootCoordinatorFeature.RootPath.Action.signUp(let signUpAction))):
                return signUpNavigation(&state, signUpAction)
//            case .path(.element(id: _, action: RootFeature.Path.Action.detail(.alert(.presented(.success))))):
//                _ = state.path.popLast()
//                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: /RootCoordinatorFeature.Action.path) {
            RootPath()
        }
    }
}

// SignIn
private extension RootCoordinatorFeature {
    private func signInNavigation(_ state: inout State, _ action: SignInFeature.Action) -> Effect<Action> {
        switch action {
        case .navigateToSignUp:
            state.path.append(.signUp(SignUpFeature.State()))
            return .none
        default:
            return .none
        }
    }
}

// SignUp
private extension RootCoordinatorFeature {
    private func signUpNavigation(_ state: inout State, _ action: SignUpFeature.Action) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            state.isAuth = true
            return .none
        default:
            return .none
        }
    }
}

extension PersistenceReaderKey where Self == InMemoryKey<Bool> {
    static var auth: Self {
        inMemory("auth")
    }
}