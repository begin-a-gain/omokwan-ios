//
//  NotificationRepositoryProtocol.swift
//  Domain
//
//  Created by jumy on 3/14/26.
//

public protocol NotificationRepositoryProtocol {
    func getNotificationList(_ filter: NotificationFilter) async -> Result<[NotificationInfo], NetworkError>
}
