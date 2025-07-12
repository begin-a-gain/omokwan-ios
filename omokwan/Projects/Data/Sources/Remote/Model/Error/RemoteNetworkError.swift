//
//  RemoteNetworkError.swift
//  Data
//
//  Created by 김동준 on 6/9/25
//

import Foundation

enum RemoteNetworkError: Error {
    // MARK: 400대
    case badRequest
    case unAuthorizationError
    case forbidden
    case notFound
    case clientError

    // MARK: 500대
    case internalServerError
    case serverMaintenanceError
    case gatewayTimeout
    case serverUnknownError
    
    // MARK: URLError
    case urlError(URLError)
    
    // MARK: 그외
    case unKnownError
    case decodingError(DecodingError)
    case responseError
    case queryParameterError
    case bodyEncodingError
    case requestURLNotExistError
    case timeout
    case internetConnectionError
    case responseDataNilError
}
