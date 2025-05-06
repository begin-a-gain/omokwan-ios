//
//  GameRoomInformation.swift
//  Domain
//
//  Created by 김동준 on 4/28/25
//

import Foundation

public struct GameRoomInformation: Hashable {
    public let title: String
    public let isPrivateRoom: Bool
    public let currentNumOfPeople: Int
    public let maxNumOfPeople: Int
    public let category: GameCategory?
    public let createRoomDate: Date
    public let hostName: String
    public let roomStatus: RoomParticipationStatus
    
    public init(
        title: String,
        isPrivateRoom: Bool,
        currentNumOfPeople: Int,
        maxNumOfPeople: Int,
        category: GameCategory?,
        createRoomDate: Date,
        hostName: String,
        roomStatus: RoomParticipationStatus
    ) {
        self.title = title
        self.isPrivateRoom = isPrivateRoom
        self.currentNumOfPeople = currentNumOfPeople
        self.maxNumOfPeople = maxNumOfPeople
        self.category = category
        self.createRoomDate = createRoomDate
        self.hostName = hostName
        self.roomStatus = roomStatus
    }
}

public enum RoomParticipationStatus {
    case participating
    case available
    case unavailable
}
