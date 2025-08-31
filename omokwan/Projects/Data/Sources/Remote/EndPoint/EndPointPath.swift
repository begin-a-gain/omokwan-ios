//
//  EndPointPath.swift
//  Data
//
//  Created by 김동준 on 8/17/25
//

enum EndPointPath {
    case getHealthCheck
    case postSignIn(String)
    case postNicknameDuplicated
    case putNickname
    case getUserInfo
    case postRefreshToken
    case getGameInfoFromDate
    case postCreateGame
    case getGameCategories
    
    var value: String {
        switch self {
        case .getHealthCheck:
            "/actuator/health"
        case .postSignIn(let provider):
            "/auth/login/\(provider)"
        case .postNicknameDuplicated:
            "/users/nicknames/validations"
        case .putNickname:
            "/users/nicknames"
        case .getUserInfo:
            "/users/info"
        case .postRefreshToken:
            "/auth/token/refresh"
        case .getGameInfoFromDate:
            "/matches"
        case .postCreateGame:
            "/matches"
        case .getGameCategories:
            "/matches/categories"
        }
    }
}
