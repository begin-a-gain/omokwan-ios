//
//  PermissionUseCase.swift
//  Domain
//
//  Created by jumy on 3/20/26.
//

import Dependencies
import AppTrackingTransparency

public struct PermissionUseCase {
    public let needTrackingAuthorization: () -> Bool
    public let isTrackingAuthorized: () -> Bool
    public let requestTrackingAuthorizationAndCheckAuthorized: () async -> Bool
}

extension PermissionUseCase: DependencyKey {
    public static var liveValue: PermissionUseCase = .init(
        needTrackingAuthorization: {
            let status = ATTrackingManager.trackingAuthorizationStatus
            return status == .notDetermined
        },
        isTrackingAuthorized: {
            let status = ATTrackingManager.trackingAuthorizationStatus
            return status == .authorized
        },
        requestTrackingAuthorizationAndCheckAuthorized: {
            let status = await ATTrackingManager.requestTrackingAuthorization()
            return status == .authorized
        }
    )
}

extension PermissionUseCase {
    public static var mockValue: PermissionUseCase = .init(
        needTrackingAuthorization: { false },
        isTrackingAuthorized: { true },
        requestTrackingAuthorizationAndCheckAuthorized: { true }
    )
}

extension DependencyValues {
    public var permissionUseCase: PermissionUseCase {
        get { self[PermissionUseCase.self] }
        set { self[PermissionUseCase.self] = newValue }
    }
}
