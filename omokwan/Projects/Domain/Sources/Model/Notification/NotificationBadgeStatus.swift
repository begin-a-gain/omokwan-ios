//
//  NotificationBadgeStatus.swift
//  Domain
//
//  Created by jumy on 3/14/26.
//

public struct NotificationBadgeStatus: Equatable {
    public let hasBadge: Bool
    
    public init(hasBadge: Bool) {
        self.hasBadge = hasBadge
    }
}
