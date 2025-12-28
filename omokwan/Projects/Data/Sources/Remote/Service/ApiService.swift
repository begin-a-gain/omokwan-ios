//
//  ApiService.swift
//  Data
//
//  Created by 김동준 on 9/15/24
//

import Foundation
import Domain

public final class ApiService {
    let tokenProvider: TokenProvider
    
    public init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func call<T: Decodable>(_ endPoint: EndPoint<T>, retryCount: Int = 1) async throws -> T {
        do {
            let urlRequest = try makeRequest(endPoint)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let statusCode = try extractStatusCode(response)
            
            logResponse(
                request: urlRequest,
                data: data,
                response: response
            )
            
            guard let error = mapStatusCodeToRemoteNetworkError(statusCode) else {
                return try await handleSuccessResponse(
                    data: data,
                    response: response,
                    endPoint: endPoint
                )
            }
            
            return try await handleErrorResponse(
                error: error,
                endPoint: endPoint,
                retryCount: retryCount
            )
        } catch {
            try handleNetworkError(error)
        }
    }
}
