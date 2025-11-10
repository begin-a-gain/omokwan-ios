//
//  AnalyticsManager.swift
//  Util
//
//  Created by 김동준 on 11/9/25
//

import FirebaseAnalytics

public final class AnalyticsManager {
    public static let shared = AnalyticsManager()
    
    private init() {}
    
    public func logScreen(_ screenName: String, screenClass: String? = nil) {
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: screenName,
                AnalyticsParameterScreenClass: screenClass ?? screenName
            ]
        )
    }
    
    public func logButtonTap(_ buttonName: String, screen: String? = nil) {
        var parameters: [String: Any] = [
            "button_name": buttonName
        ]
        
        if let screen = screen {
            parameters["screen_name"] = screen
        }
        
        Analytics.logEvent("button_tap", parameters: parameters)
    }
    
    public func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
    
    public func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
    }
    
    public func setAnalyticsEnabled(_ enabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }
}
