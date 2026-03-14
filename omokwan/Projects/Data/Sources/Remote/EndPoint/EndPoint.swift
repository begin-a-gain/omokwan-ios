//
//  EndPoint.swift
//  Data
//
//  Created by 김동준 on 6/9/25
//

import Domain

struct EndPoint<T>: EndPointProtocol {
    public var path: EndPointPath
    public var method: HttpMethod
    public var headers: [String: String]?
    public var queryParameters: Encodable?
    public var requestBody: Encodable?
    
    public init(
        path: EndPointPath,
        method: HttpMethod,
        headers: [String: String]? = nil,
        queryParameters: Encodable? = nil,
        requestBody: Encodable? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.requestBody = requestBody
    }
}

// MARK: Server
extension EndPoint {
    static func getHealthCheck() -> EndPoint<T> {
        return EndPoint(path: .getHealthCheck, method: .GET)
    }
}

// MARK: Account
extension EndPoint {
    static func postSignIn<Body: Encodable>(provider: String, requestBody: Body) -> EndPoint<T> {
        return EndPoint(path: .postSignIn(provider), method: .POST, requestBody: requestBody)
    }
    
    static func postNicknameDuplicated(requestBody: NicknameValidationRequest) -> EndPoint<T> {
        return EndPoint(path: .postNicknameDuplicated, method: .POST, requestBody: requestBody)
    }
    
    static func putNickname(requestBody: UpdateNicknameRequest) -> EndPoint<T> {
        return EndPoint(path: .putNickname, method: .PUT, requestBody: requestBody)
    }
    
    static func getUserInfo() -> EndPoint<T> {
        return EndPoint(path: .getUserInfo, method: .GET)
    }
    
    static func postRefreshToken(refreshToken: String) -> EndPoint<T> {
        return EndPoint(
            path: .postRefreshToken,
            method: .POST,
            headers: ["Cookie": "refresh_token=\(refreshToken)"]
        )
    }
    
    static func postDeletionSurvey(requestBody: DeletionSurveyRequest) -> EndPoint<T> {
        return EndPoint(
            path: .postDeletionSurvey,
            method: .POST,
            requestBody: requestBody
        )
    }
    
    static func deleteUserAccount() -> EndPoint<T> {
        return EndPoint(
            path: .deleteUserAccount,
            method: .DELETE
        )
    }
}

// MARK: Game
extension EndPoint {
    static func getGameInfoFromDate(queryParameters: GameInfoRequest) -> EndPoint<T> {
        return EndPoint(path: .getGameInfoFromDate, method: .GET, queryParameters: queryParameters)
    }
    
    static func postCreateGame(requestBody: CreateGameRequest) -> EndPoint<T> {
        return EndPoint(path: .postCreateGame, method: .POST, requestBody: requestBody)
    }
    
    static func getGameCategories() -> EndPoint<T> {
        return EndPoint(path: .getGameCategories, method: .GET)
    }
    
    static func getDetailInfoWithPaging(gameID: Int, request: GameDetailPagingRequest) -> EndPoint<T> {
        return EndPoint(
            path: .getDetailInfoWithPaging(gameID),
            method: .GET,
            queryParameters: request
        )
    }
    
    static func getDetailUserInfo(gameID: Int, userID: Int) -> EndPoint<T> {
        return EndPoint(
            path: .getDetailUserInfo(gameID, userID),
            method: .GET
        )
    }
    
    static func putTodayGameStatus(gameID: Int, queryParameters: TodayGameStatusRequest) -> EndPoint<T> {
        return EndPoint(
            path: .putTodayGameStatus(gameID),
            method: .PUT,
            queryParameters: queryParameters
        )
    }
    
    static func getAllGameInfoList(queryParameters: AllGameInfoListRequest) -> EndPoint<T> {
        return EndPoint(
            path: .getAllGameInfoList,
            method: .GET,
            queryParameters: queryParameters
        )
    }
    
    static func postParticipateRoom(gameID: Int, request: ParticipateRoomRequest) -> EndPoint<T> {
        return EndPoint(
            path: .postParticipateRoom(gameID),
            method: .POST,
            requestBody: request
        )
    }
    
    static func getGameParticipants(gameID: Int) -> EndPoint<T> {
        return EndPoint(
            path: .getGameParticipants(gameID),
            method: .GET
        )
    }
    
    static func putGameHost(gameID: Int, request: HostChangeRequest) -> EndPoint<T> {
        return EndPoint(
            path: .putGameHost(gameID),
            method: .PUT,
            requestBody: request
        )
    }
    
    static func getGameDetailSetting(gameID: Int) -> EndPoint<T> {
        return EndPoint(
            path: .getGameDetailSetting(gameID),
            method: .GET
        )
    }
    
    static func postKickUser(gameID: Int, userID: Int) -> EndPoint<T> {
        return EndPoint(
            path: .postKickUser(gameID, userID),
            method: .POST
        )
    }
    
    static func deleteGame(gameID: Int) -> EndPoint<T> {
        return EndPoint(
            path: .deleteGame(gameID),
            method: .DELETE
        )
    }
    
    static func getMyPage(userID: Int) -> EndPoint<T> {
        return EndPoint(
            path: .getMyPage(userID),
            method: .GET
        )
    }
    
    static func putGameDetailSetting(gameID: Int, request: GameDetailSettingRequestDTO) -> EndPoint<T> {
        return EndPoint(
            path: .putGameDetailSetting(gameID),
            method: .PUT,
            requestBody: request
        )
    }
    
    static func postInviteUsers(gameID: Int, request: InviteUsersRequest) -> EndPoint<T> {
        return EndPoint(
            path: .postInviteUsers(gameID),
            method: .POST,
            requestBody: request
        )
    }
}

// MARK: Notification
extension EndPoint {
    static func getNotificationList(_ queryParameters: NotificationFilterRequest) -> EndPoint<T> {
        return EndPoint(
            path: .getNotiList,
            method: .GET,
            queryParameters: queryParameters
        )
    }
    
    static func getNotificationBadgeStatus() -> EndPoint<T> {
        return EndPoint(
            path: .getNotiBadgeStatus,
            method: .GET
        )
    }
}
