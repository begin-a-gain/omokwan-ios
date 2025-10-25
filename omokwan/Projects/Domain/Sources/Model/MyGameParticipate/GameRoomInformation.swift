//
//  GameRoomInformation.swift
//  Domain
//
//  Created by 김동준 on 4/28/25
//

import Foundation

public struct GameRoomInformation: Hashable {
    public let id: Int
    public let category: GameCategory?
    public let name: String
    public let hostName: String
    public let ongoingDays: Int
    public let participants: Int
    public let maxParticipants: Int
    public let joinStatus: RoomJoinStatus
    public let isPublic: Bool
    
    public init(
        id: Int,
        category: GameCategory?,
        name: String,
        hostName: String,
        ongoingDays: Int,
        participants: Int,
        maxParticipants: Int,
        joinStatus: RoomJoinStatus,
        isPublic: Bool
    ) {
        self.id = id
        self.category = category
        self.name = name
        self.hostName = hostName
        self.ongoingDays = ongoingDays
        self.participants = participants
        self.maxParticipants = maxParticipants
        self.joinStatus = joinStatus
        self.isPublic = isPublic
    }
}

public enum RoomJoinStatus {
    case possible
    case impossible
    case inProgress
}
