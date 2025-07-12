//
//  RemoteKakaoSignInError.swift
//  Data
//
//  Created by 김동준 on 7/12/25
//

enum RemoteKakaoSignInError: Error {
    case cancelled
    case error(Error)
    case unknownError
}
