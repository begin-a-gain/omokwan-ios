//
//  AnalyticsUseCase.swift
//  Domain
//
//  Created by jumy on 3/20/26.
//

import DI
import Dependencies

public struct AnalyticsUseCase {
    public let track: (_ event: AnalyticsEvent) -> Void
    public let setUserId: (_ userId: String?) -> Void
    public let setAnalyticsEnabled: (_ enabled: Bool) -> Void
}

extension AnalyticsUseCase: DependencyKey {
    public static var liveValue: AnalyticsUseCase = {
        let repository: AnalyticsRepositoryProtocol = DIContainer.shared.resolve()

        return .init(
            track: { event in
                repository.track(event)
            },
            setUserId: { userId in
                repository.setUserId(userId)
            },
            setAnalyticsEnabled: { enabled in
                repository.setAnalyticsEnabled(enabled)
            }
        )
    }()
}

extension AnalyticsUseCase {
    public static var mockValue: AnalyticsUseCase = .init(
        track: { _ in },
        setUserId: { _ in },
        setAnalyticsEnabled: { _ in }
    )
}

extension DependencyValues {
    public var analyticsUseCase: AnalyticsUseCase {
        get { self[AnalyticsUseCase.self] }
        set { self[AnalyticsUseCase.self] = newValue }
    }
}
