//
//  EndPoint.swift
//  Data
//
//  Created by 김동준 on 6/9/25
//

struct EndPoint<T>: EndPointProtocol {
    public var path: String
    public var method: HttpMethod
    public var headers: [String: String]?
    public var queryParameters: Encodable?
    public var requestBody: Encodable?
    
    public init(
        path: String,
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
        return EndPoint(path: "/actuator/health", method: .GET)
    }
}

// MARK: Account
extension EndPoint {
    static func postSignIn(provider: String, requestBody: SignInRequest) -> EndPoint<T> {
        return EndPoint(path: "/auth/login/\(provider)", method: .POST, requestBody: requestBody)
    }
    
    static func postNicknameDuplicated(requestBody: NicknameValidationRequest) -> EndPoint<T> {
        return EndPoint(path: "/users/nicknames/validations", method: .POST, requestBody: requestBody)
    }
    
    static func putNickname(requestBody: UpdateNicknameRequest) -> EndPoint<T> {
        return EndPoint(path: "/users/nicknames", method: .PUT, requestBody: requestBody)
    }
    
    static func getUserInfo() -> EndPoint<T> {
        return EndPoint(path: "/users/info", method: .GET)
    }
}

// MARK: Game
extension EndPoint {
    static func getGameInfoFromDate(queryParameters: GameInfoRequest) -> EndPoint<T> {
        return EndPoint(path: "/matches", method: .GET, queryParameters: queryParameters)
    }
    
    static func postCreateGame(requestBody: CreateGameRequest) -> EndPoint<T> {
        return EndPoint(path: "/matches", method: .POST, requestBody: requestBody)
    }
}
