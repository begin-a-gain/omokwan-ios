//
//  FirebaseUseCase.swift
//  Domain
//
//  Created by 김동준 on 11/9/25
//

import DI
import Dependencies

public struct FirebaseUseCase {
    public let needTrackingAuthorization: () -> Bool
    public let isTrackingAuthorized: () -> Bool
    public let requestTrackingAuthorizationAndCheckAuthorized: () async -> Bool
}

extension FirebaseUseCase: DependencyKey {
    public static var liveValue: FirebaseUseCase = {
        let repository: FirebaseRepositoryProtocol = DIContainer.shared.resolve()
        
        return .init(
            needTrackingAuthorization: {
                repository.needTrackingAuthorization()
            },
            isTrackingAuthorized: {
                repository.isTrackingAuthorized()
            },
            requestTrackingAuthorizationAndCheckAuthorized: {
                await repository.requestTrackingAuthorizationAndCheckAuthorized()
            }
        )
    }()
}

extension FirebaseUseCase {
    public static var mockValue: FirebaseUseCase = .init(
        needTrackingAuthorization: { false },
        isTrackingAuthorized: { true },
        requestTrackingAuthorizationAndCheckAuthorized: { true }
    )
}

extension DependencyValues {
    public var firebaseUseCase: FirebaseUseCase {
        get { self[FirebaseUseCase.self] }
        set { self[FirebaseUseCase.self] = newValue }
    }
}
