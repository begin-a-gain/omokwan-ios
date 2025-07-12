//
//  KakaoSignInError.swift
//  Domain
//
//  Created by 김동준 on 7/12/25
//

public enum KakaoSignInError: Error {
    case tokenNilError
    case unKnownError
    case error(Error)
}
