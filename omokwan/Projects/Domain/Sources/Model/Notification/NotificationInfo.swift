//
//  NotificationInfo.swift
//  Domain
//
//  Created by jumy on 3/14/26.
//

import Foundation

public struct NotificationInfo: Equatable {
    public let id: Int
    public let gameID: Int
    public let isRead: Bool
    public let createdDate: Date
    public let type: NotificationType
    public let title: String
    public let targetName: String?
    public let previousHostName: String?
    public let newHostName: String?
    
    public init(
        id: Int = 0,
        gameID: Int = 0,
        isRead: Bool = true,
        createdDate: Date = .now,
        type: NotificationType = .joined,
        title: String = "-",
        targetName: String? = nil,
        previousHostName: String? = nil,
        newHostName: String? = nil
    ) {
        self.id = id
        self.gameID = gameID
        self.isRead = isRead
        self.createdDate = createdDate
        self.type = type
        self.title = title
        self.targetName = targetName
        self.previousHostName = previousHostName
        self.newHostName = newHostName
    }
}
