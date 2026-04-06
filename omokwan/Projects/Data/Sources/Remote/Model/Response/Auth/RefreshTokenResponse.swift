//
//  RefreshTokenResponse.swift
//  Data
//
//  Created by 김동준 on 8/17/25
//

struct RefreshTokenResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
}
