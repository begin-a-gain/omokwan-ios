//
//  SignInCoordinatorView.swift
//  SignIn
//
//  Created by 김동준 on 9/25/25
//

import SwiftUI
import ComposableArchitecture
import SignUp

public struct SignInCoordinatorView: View {
    @Bindable private var store: StoreOf<SignInCoordinatorFeature>

    public init(store: StoreOf<SignInCoordinatorFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.navigationPath, action: \.navigationPath)) {
            SignInView(store: store.scope(state: \.signInState, action: \.signInAction))
        } destination: { store in
            switch store.case {
            case .signUp(let store):
                SignUpView(store: store)
            }
        }
    }
}
