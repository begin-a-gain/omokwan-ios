//
//  SignInPath.swift
//  SignIn
//
//  Created by 김동준 on 9/25/25
//

import ComposableArchitecture
import SignUp

extension SignInCoordinatorFeature {
    @Reducer
    public enum SignInPath {
        case signUp(SignUpFeature)
    }
}
