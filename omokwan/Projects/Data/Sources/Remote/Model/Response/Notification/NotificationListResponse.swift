//
//  NotificationListResponse.swift
//  Data
//
//  Created by jumy on 3/14/26.
//

import Foundation

struct NotificationListResponse: Decodable {
    let notifications: [NotificationResponse]?
}

struct NotificationResponse: Decodable {
    let notificationId: Int?
    let type: String?
    let isRead: Bool?
    let occurredAt: String?
    let matchName: String?
    let actorNickname: String?
    let prevHostNickname: String?
    let newHostNickname: String?
}
