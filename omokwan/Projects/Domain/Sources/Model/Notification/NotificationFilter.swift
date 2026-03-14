//
//  NotificationFilter.swift
//  Domain
//
//  Created by jumy on 3/14/26.
//

public enum NotificationFilter {
    case all
    case unread
    
    public var name: String {
        switch self {
        case .all: "all"
        case .unread: "unread"
        }
    }
}
