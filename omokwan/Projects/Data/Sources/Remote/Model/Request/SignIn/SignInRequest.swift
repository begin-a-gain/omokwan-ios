//
//  SignInRequest.swift
//  Data
//
//  Created by 김동준 on 7/12/25
//

struct KakaoSignInRequest: Encodable {
    let accessToken: String
}

struct AppleSignInRequest: Encodable {
    let identityToken: String
}

struct TesterSignInRequest: Encodable {
    let token: String?
}
