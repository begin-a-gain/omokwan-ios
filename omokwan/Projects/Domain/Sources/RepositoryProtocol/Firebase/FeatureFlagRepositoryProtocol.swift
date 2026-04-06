//
//  FeatureFlagRepositoryProtocol.swift
//  Domain
//
//  Created by jumy on 4/8/26.
//

public protocol FeatureFlagRepositoryProtocol {
    func setFeatureFlags(_ info: FeatureFlagInfo)
    func getFeatureFlags() -> FeatureFlagInfo
    func isNotificationEnabled() -> Bool
}
