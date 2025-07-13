//
//  AccountRepositoryProtocol.swift
//  Domain
//
//  Created by 김동준 on 9/15/24
//

public protocol AccountRepositoryProtocol {
    func postSignIn(provider: String, accessToken: String) async -> Result<SignInResult, NetworkError>
}
