//
//  FirebaseRepositoryProtocol.swift
//  Domain
//
//  Created by jumy on 3/20/26.
//

public protocol FirebaseRepositoryProtocol {
    func needTrackingAuthorization() -> Bool
    func isTrackingAuthorized() -> Bool
    func requestTrackingAuthorizationAndCheckAuthorized() async -> Bool
}
