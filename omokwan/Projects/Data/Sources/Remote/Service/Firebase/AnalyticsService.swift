//
//  AnalyticsService.swift
//  Data
//
//  Created by jumy on 3/20/26.
//

import FirebaseAnalytics

public final class AnalyticsService {
    public init() {}

    public func logScreen(_ screenName: String, screenClass: String?) {
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: screenName,
                AnalyticsParameterScreenClass: screenClass ?? screenName
            ]
        )
    }

    public func logButtonTap(_ buttonName: String, screen: String?) {
        var parameters: [String: Any] = ["button_name": buttonName]
        if let screen { parameters["screen_name"] = screen }

        Analytics.logEvent("button_tap", parameters: parameters)
    }

    public func logEvent(_ eventName: String, parameters: [String: Any]?) {
        Analytics.logEvent(eventName, parameters: parameters)
    }

    public func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
    }

    public func setAnalyticsEnabled(_ enabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }
}
