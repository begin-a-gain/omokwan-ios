//
//  MyGameModel.swift
//  Domain
//
//  Created by 김동준 on 12/14/24
//

public struct MyGameModel: Equatable {
    public let gameID: Int
    public let name: String
    public let onGoingDays: Int
    public let participants: Int
    public let maxParticipants: Int
    public let myGameCompleteStatus: MyGameCompleteStatus
    public let participateStatus: ParticipateStatus
    public let isPrivateRoom: Bool
    
    public init(
        gameID: Int,
        name: String,
        onGoingDays: Int,
        participants: Int,
        maxParticipants: Int,
        myGameCompleteStatus: MyGameCompleteStatus,
        participateStatus: ParticipateStatus,
        isPrivateRoom: Bool
    ) {
        self.gameID = gameID
        self.name = name
        self.onGoingDays = onGoingDays
        self.participants = participants
        self.maxParticipants = maxParticipants
        self.myGameCompleteStatus = myGameCompleteStatus
        self.participateStatus = participateStatus
        self.isPrivateRoom = isPrivateRoom
    }
}

public enum MyGameCompleteStatus {
    case complete
    case inComplete
    case inCompleteWithSkip
}

public enum ParticipateStatus: String {
    case active = "ACTIVE"
    case left = "LEFT"
    case kicked = "KICKED"
    case done = "DONE"
}
