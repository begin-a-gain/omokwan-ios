//
//  FeatureFlagRepository.swift
//  Data
//
//  Created by jumy on 4/8/26.
//

import Domain

public struct FeatureFlagRepository: FeatureFlagRepositoryProtocol {
    private let featureFlagStore: FeatureFlagStore

    public init(featureFlagStore: FeatureFlagStore) {
        self.featureFlagStore = featureFlagStore
    }

    public func setFeatureFlags(_ info: FeatureFlagInfo) {
        featureFlagStore.set(info)
    }

    public func getFeatureFlags() -> FeatureFlagInfo {
        featureFlagStore.get()
    }

    public func isNotificationEnabled() -> Bool {
        featureFlagStore.get().notificationFlag
    }
}
