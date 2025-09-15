//
//  EndPoint.swift
//  Data
//
//  Created by 김동준 on 6/9/25
//

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
    static func postSignIn(provider: String, requestBody: SignInRequest) -> EndPoint<T> {
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
    
    static func postRefreshToken() -> EndPoint<T> {
        return EndPoint(path: .postRefreshToken, method: .POST)
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
}
