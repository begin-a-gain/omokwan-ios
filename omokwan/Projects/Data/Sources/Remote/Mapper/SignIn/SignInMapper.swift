//
//  SignInMapper.swift
//  Data
//
//  Created by 김동준 on 7/12/25
//

import Domain

struct SignInMapper {
    static func toSignInResult(_ response: SignInResponse?) throws -> SignInResult {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return SignInResult(
            accessToken: response.accessToken ?? "",
            signUpComplete: response.signUpComplete ?? false
        )
    }
}
