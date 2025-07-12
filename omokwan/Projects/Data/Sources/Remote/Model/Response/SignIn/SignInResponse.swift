//
//  SignInResponse.swift
//  Data
//
//  Created by 김동준 on 7/12/25
//

struct SignInResponse: Decodable {
    let accessToken: String?
    let signUpComplete: Bool?
}
