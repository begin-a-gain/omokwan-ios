//
//  FeatureFlagUseCase.swift
//  Domain
//
//  Created by jumy on 4/8/26.
//

import DI
import Dependencies

public struct FeatureFlagUseCase {
    public let setFeatureFlags: (_ info: FeatureFlagInfo) -> Void
    public let getFeatureFlags: () -> FeatureFlagInfo
    public let isNotificationFlagEnabled: () -> Bool
}

extension FeatureFlagUseCase: DependencyKey {
    public static var liveValue: FeatureFlagUseCase = {
        let repository: FeatureFlagRepositoryProtocol = DIContainer.shared.resolve()

        return .init(
            setFeatureFlags: { info in
                repository.setFeatureFlags(info)
            },
            getFeatureFlags: {
                repository.getFeatureFlags()
            },
            isNotificationFlagEnabled: {
                repository.isNotificationEnabled()
            }
        )
    }()
}

extension FeatureFlagUseCase {
    public static var mockValue: FeatureFlagUseCase = .init(
        setFeatureFlags: { _ in },
        getFeatureFlags: { .init() },
        isNotificationFlagEnabled: { true }
    )
}

extension DependencyValues {
    public var featureFlagUseCase: FeatureFlagUseCase {
        get { self[FeatureFlagUseCase.self] }
        set { self[FeatureFlagUseCase.self] = newValue }
    }
}
