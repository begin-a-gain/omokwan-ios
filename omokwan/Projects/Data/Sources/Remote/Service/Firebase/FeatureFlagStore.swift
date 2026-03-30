//
//  FeatureFlagStore.swift
//  Data
//
//  Created by jumy on 4/8/26.
//

import Domain
import Foundation

public final class FeatureFlagStore: @unchecked Sendable {
    private var featureFlags: FeatureFlagInfo = .init()
    private let lock = NSLock()

    public init() {}

    public func set(_ featureFlags: FeatureFlagInfo) {
        lock.lock()
        defer { lock.unlock() }
        self.featureFlags = featureFlags
    }

    public func get() -> FeatureFlagInfo {
        lock.lock()
        defer { lock.unlock() }
        return featureFlags
    }
}
