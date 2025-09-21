//
//  DetailUserInfo.swift
//  Domain
//
//  Created by 김동준 on 9/15/25
//

public struct DetailUserInfo: Equatable {
    public let nickname: String
    public let combo: Int
    public let stones: Int
    public let participantDays: Int
    
    public init(
        nickname: String,
        combo: Int,
        stones: Int,
        participantDays: Int
    ) {
        self.nickname = nickname
        self.combo = combo
        self.stones = stones
        self.participantDays = participantDays
    }
}
