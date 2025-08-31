//
//  AuthMapper.swift
//  Data
//
//  Created by 김동준 on 8/17/25
//

import Domain

struct AuthMapper {
    static func toRefreshTokenResult(_ response: RefreshTokenResponse?) -> (String, String) {
        let accessToken = response?.accessToken ?? ""
        let refreshToken = response?.refreshToken ?? ""
        
        return (accessToken, refreshToken)
    }
}
