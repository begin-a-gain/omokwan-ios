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
    case getDetailInfoWithPaging(Int)
    case getDetailUserInfo(Int, Int)
    case putTodayGameStatus(Int)
    case getAllGameInfoList
    case postParticipateRoom(Int)
    case getGameParticipants(Int)
    case putGameHost(Int)
    case postDeletionSurvey
    case deleteUserAccount
    case getGameDetailSetting(Int)
    case postKickUser(Int, Int)
    case deleteGame(Int)
    case getMyPage(Int)
    case putGameDetailSetting(Int)
    case postInviteUsers(Int)

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
        case .getDetailInfoWithPaging(let id):
            "/matches/\(id)/board"
        case let .getDetailUserInfo(gameID, userID):
            "/matches/\(gameID)/users/\(userID)"
        case .putTodayGameStatus(let id):
            "/matches/\(id)/status"
        case .getAllGameInfoList:
            "/matches/all"
        case .postParticipateRoom(let gameID):
            "/matches/\(gameID)/participants"
        case .getGameParticipants(let gameID):
            "/matches/\(gameID)/participants"
        case .putGameHost(let gameID):
            "/matches/\(gameID)/host"
        case .postDeletionSurvey:
            "/users/me/deletion-survey"
        case .deleteUserAccount:
            "/users/me"
        case .getGameDetailSetting(let gameID):
            "/matches/\(gameID)/settings"
        case let .postKickUser(gameID, userID):
            "/matches/\(gameID)/users/\(userID)/kick"
        case .deleteGame(let gameID):
            "/matches/\(gameID)/participants/me"
        case .getMyPage(let userID):
            "/users/\(userID)/mypage"
        case .putGameDetailSetting(let gameID):
            "/matches/\(gameID)/settings"
        case .postInviteUsers(let gameID):
            "/matches/\(gameID)/invites"
        }
    }
}
