//
//  ApiService+StatusCode.swift
//  Data
//
//  Created by 김동준 on 12/28/25
//

import Foundation

extension ApiService {
    func extractStatusCode(_ response: URLResponse) throws -> Int {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw RemoteNetworkError.responseError
        }
        return statusCode
    }

    func mapStatusCodeToRemoteNetworkError(_ code: Int) -> RemoteNetworkError? {
        switch code {
        case 200...299: return nil
        case 400: return .badRequest
        case 401: return .unAuthorizationError
        case 403: return .forbidden
        case 404: return .notFound
        case 400...499: return .clientError
        case 500: return .internalServerError
        case 503: return .serverMaintenanceError
        case 504: return .gatewayTimeout
        case 500...599: return .serverUnknownError
        default: return .unKnownError
        }
    }
}
