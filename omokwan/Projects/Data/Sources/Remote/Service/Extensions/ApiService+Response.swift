//
//  ApiService+Response.swift
//  Data
//
//  Created by 김동준 on 12/28/25
//

import Foundation

extension ApiService {
    func handleSuccessResponse<T: Decodable>(
        data: Data,
        response: URLResponse,
        endPoint: EndPoint<T>
    ) async throws -> T {
        do {
            if data.isEmpty {
                return try handleEmptyResponse()
            }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            checkCookieForRefreshToken(
                path: endPoint.path.value,
                response: response
            )
            return decodedResponse
        } catch let error as DecodingError {
            throw RemoteNetworkError.decodingError(error)
        } catch {
            throw RemoteNetworkError.unKnownError
        }
    }
    
    func handleErrorResponse<T: Decodable>(
        error: RemoteNetworkError,
        endPoint: EndPoint<T>,
        retryCount: Int
    ) async throws -> T {
        guard case .unAuthorizationError = error,
              retryCount >= 1 else {
            throw error
        }
        
        let retryCount = retryCount - 1
        
        let isRefreshTokenPublished = await requestNewAuthorizationFromRefreshToken(retryCount)
        if isRefreshTokenPublished {
            return try await self.call(endPoint, retryCount: retryCount)
        } else {
            throw RemoteNetworkError.unAuthorizationError
        }
    }
}

private extension ApiService {
    func handleEmptyResponse<T: Decodable>() throws -> T {
        guard let emptyResponse = EmptyResponse() as? T else {
            throw RemoteNetworkError.responseDataNilError
        }
        return emptyResponse
    }
}
