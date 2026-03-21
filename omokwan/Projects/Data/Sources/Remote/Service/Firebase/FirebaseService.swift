//
//  FirebaseService.swift
//  Data
//
//  Created by OpenAI on 3/20/26.
//

import AppTrackingTransparency

public struct FirebaseService {
    public init() {}
    
    public func needTrackingAuthorization() -> Bool {
        let status = ATTrackingManager.trackingAuthorizationStatus
        return status == .notDetermined
    }
    
    public func isTrackingAuthorized() -> Bool {
        let status = ATTrackingManager.trackingAuthorizationStatus
        return status == .authorized
    }
    
    public func requestTrackingAuthorizationAndCheckAuthorized() async -> Bool {
        let status = await ATTrackingManager.requestTrackingAuthorization()
        return status == .authorized
    }
}
