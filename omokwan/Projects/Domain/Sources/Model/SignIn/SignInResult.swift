//
//  SignInResult.swift
//  Domain
//
//  Created by 김동준 on 7/12/25
//

public struct SignInResult {
    public let accessToken: String
    public let signUpComplete: Bool
    
    public init(
        accessToken: String,
        signUpComplete: Bool
    ) {
        self.accessToken = accessToken
        self.signUpComplete = signUpComplete
    }
}

