//
//  NotificationMapper.swift
//  Data
//
//  Created by jumy on 3/14/26.
//

import Domain
import Foundation
import Util

struct NotificationMapper {
    static func toNotificationInfoList(_ response: NotificationListResponse?) throws -> [NotificationInfo] {
        guard let notifications = response?.notifications else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return notifications.compactMap {
            guard let notificationId = $0.notificationId,
                  let matchId = $0.matchId,
                  let type = NotificationType(rawValue: $0.type ?? ""),
                  let createdDateString = $0.occurredAt,
                  let createdDate = createdDateString.toDate() else {
                return nil
            }
            
            return NotificationInfo(
                id: notificationId,
                gameID: matchId,
                isPublic: $0.isPublic ?? false,
                isRead: $0.isRead ?? false,
                createdDate: createdDate,
                type: type,
                title: $0.matchName ?? "-",
                targetName: $0.actorNickname,
                previousHostName: $0.prevHostNickname,
                newHostName: $0.newHostNickname
            )
        }
    }
    
    static func toNotificationBadgeStatus(_ response: NotificationBadgeResponse?) throws -> NotificationBadgeStatus {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return NotificationBadgeStatus(hasBadge: response.hasBadge ?? false)
    }
}
