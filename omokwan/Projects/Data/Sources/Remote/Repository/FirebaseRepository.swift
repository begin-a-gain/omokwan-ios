//
//  FirebaseRepository.swift
//  Data
//
//  Created by jumy on 3/20/26.
//

import Domain

public struct FirebaseRepository: FirebaseRepositoryProtocol {
    private let firebaseService: FirebaseService
    
    public init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    public func needTrackingAuthorization() -> Bool {
        firebaseService.needTrackingAuthorization()
    }
    
    public func isTrackingAuthorized() -> Bool {
        firebaseService.isTrackingAuthorized()
    }
    
    public func requestTrackingAuthorizationAndCheckAuthorized() async -> Bool {
        await firebaseService.requestTrackingAuthorizationAndCheckAuthorized()
    }
}
