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
    public let fetchNotificationBadgeStatus: () async -> Result<NotificationBadgeStatus, NetworkError>
    public let patchNotificationRead: (_ id: Int?) async -> Result<Void, NetworkError>
}

extension NotificationUseCase: DependencyKey {
    public static var liveValue: NotificationUseCase = {
        let repository: NotificationRepositoryProtocol = DIContainer.shared.resolve()
        return NotificationUseCase(
            fetchNotificationList: { filter in
                await repository.getNotificationList(filter)
            },
            fetchNotificationBadgeStatus: {
                await repository.getNotificationBadgeStatus()
            },
            patchNotificationRead: { id in
                await repository.patchNotificationRead(id: id)
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
