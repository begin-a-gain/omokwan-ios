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

extension EndPoint {
    static func getHealthCheck() -> EndPoint<T> {
        return EndPoint(path: "/actuator/health", method: .GET)
    }
    
    static func postSignIn(provider: String, requestBody: SignInRequest) -> EndPoint<T> {
        return EndPoint(path: "/auth/login/\(provider)", method: .POST, requestBody: requestBody)
    }
}
