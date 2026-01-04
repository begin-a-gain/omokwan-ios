//
//  GameParticipantInfo.swift
//  Domain
//
//  Created by 김동준 on 12/24/25
//

public struct GameParticipantInfo: Hashable {
    public let userId: Int
    public let nickname: String
    public let combo: Int
    public let participantDays: Int
    public let participantNumbers: Int
    public var isHost: Bool
    
    public init(
        userId: Int,
        nickname: String,
        combo: Int,
        participantDays: Int,
        participantNumbers: Int,
        isHost: Bool = false
    ) {
        self.userId = userId
        self.nickname = nickname
        self.combo = combo
        self.participantDays = participantDays
        self.participantNumbers = participantNumbers
        self.isHost = isHost
    }
}
