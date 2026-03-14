//
//  NotificationUseCase.swift
//  Domain
//
//  Created by jumy on 3/14/26.
//

import DI
import Dependencies

public struct NotificationUseCase {
    public let fetchNotificationList: (_ filter: NotificationFilter) async -> Result<[NotificationInfo], NetworkError>
}

extension NotificationUseCase: DependencyKey {
    public static var liveValue: NotificationUseCase = {
        let repository: NotificationRepositoryProtocol = DIContainer.shared.resolve()
        return NotificationUseCase(
            fetchNotificationList: { filter in
                await repository.getNotificationList(filter)
            }
        )
    }()
}

extension DependencyValues {
    public var notificationUseCase: NotificationUseCase {
        get { self[NotificationUseCase.self] }
        set { self[NotificationUseCase.self] = newValue }
    }
}
