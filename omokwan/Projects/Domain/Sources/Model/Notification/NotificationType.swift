//
//  NotificationType.swift
//  Domain
//
//  Created by jumy on 3/14/26.
//

public enum NotificationType: String {
    case invited = "MATCH_INVITED"
    case left = "MEMBER_LEFT"
    case hostChanged = "HOST_CHANGED"
    case joined = "MATCH_JOINED"
}
