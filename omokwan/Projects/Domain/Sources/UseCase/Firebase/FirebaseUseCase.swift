//
//  FirebaseUseCase.swift
//  Domain
//
//  Created by 김동준 on 11/9/25
//

import DI
import Dependencies
import AppTrackingTransparency

public struct FirebaseUseCase {
    public var needTrackingAuthorization: Bool {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            return status == .notDetermined
        }
        return false // iOS 14 미만은 권한 불필요
    }
    public var isTrackingAuthorized: Bool {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            return status == .authorized
        }
        return true // iOS 14 미만은 권한 불필요
    }
    
    @available(iOS 14, *)
    public func requestTrackingAuthorizationAndCheckAuthorized() async -> Bool {
        let status = await ATTrackingManager.requestTrackingAuthorization()
        return status == .authorized
    }
}

extension FirebaseUseCase: DependencyKey {
    public static let liveValue = FirebaseUseCase()
}

extension DependencyValues {
    public var firebaseUseCase: FirebaseUseCase {
        get { self[FirebaseUseCase.self] }
        set { self[FirebaseUseCase.self] = newValue }
    }
}
