//
//  NetworkError.swift
//  Domain
//
//  Created by 김동준 on 9/15/24
//

public enum NetworkError: Error {
    case internalServerError
    case unAuthorizationError
    case unKnownError
    case timeout
    case responseError
}
