//
//  ErrorMapper.swift
//  Data
//
//  Created by 김동준 on 7/12/25
//

import Domain

struct ErrorMapper {
    static func toNetworkError(_ error: Error) -> NetworkError {
        if let remoteError = error as? RemoteNetworkError {
            return mapRemoteResponseError(remoteError)
        }
        
        return .unKnownError
    }
}

extension ErrorMapper {
    static func mapRemoteResponseError(_ error: RemoteNetworkError) -> NetworkError {
        switch error {
        case .unAuthorizationError:
            return .unAuthorizationError
        case .badRequest, .forbidden, .notFound, .clientError:
            return .clientError
        case .internalServerError, .serverMaintenanceError, .gatewayTimeout, .serverUnknownError:
            return .internalServerError
        case .timeout:
            return .timeout
        default:
            return .unKnownError
        }
    }
}
