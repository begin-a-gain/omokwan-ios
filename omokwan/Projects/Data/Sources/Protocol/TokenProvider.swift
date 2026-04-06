//
//  TokenProvider.swift
//  Data
//
//  Created by 김동준 on 7/13/25
//

public protocol TokenProvider {
    func getAccessToken() -> String
    func setAccessToken(_ accessToken: String)
    func getRefreshToken() -> String
    func setRefreshToken(_ refreshToken: String)
}
