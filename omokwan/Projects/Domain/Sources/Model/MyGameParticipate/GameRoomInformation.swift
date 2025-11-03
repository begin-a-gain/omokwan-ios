//
//  GameRoomInformation.swift
//  Domain
//
//  Created by 김동준 on 4/28/25
//

import Foundation

public struct GameRoomInfo: Hashable {
    public let gameRoomInformation: [GameRoomInformation]
    public let hasNext: Bool
    
    public init(
        gameRoomInformation: [GameRoomInformation],
        hasNext: Bool
    ) {
        self.gameRoomInformation = gameRoomInformation
        self.hasNext = hasNext
    }
}

public struct GameRoomInformation: Hashable {
    public let id: Int
    public let categoryId: Int?
    public let name: String
    public let hostName: String
    public let ongoingDays: Int
    public let participants: Int
    public let maxParticipants: Int
    public let joinStatus: RoomJoinStatus
    public let isPublic: Bool
    
    public init(
        id: Int,
        categoryId: Int?,
        name: String,
        hostName: String,
        ongoingDays: Int,
        participants: Int,
        maxParticipants: Int,
        joinStatus: RoomJoinStatus,
        isPublic: Bool
    ) {
        self.id = id
        self.categoryId = categoryId
        self.name = name
        self.hostName = hostName
        self.ongoingDays = ongoingDays
        self.participants = participants
        self.maxParticipants = maxParticipants
        self.joinStatus = joinStatus
        self.isPublic = isPublic
    }
}

public enum RoomJoinStatus: String {
    case possible = "JOINABLE"
    case impossible = "NOT_JOINABLE"
    case inProgress = "IN_PROGRESS"
}
