//
//  GameParticipantsResponse.swift
//  Data
//
//  Created by 김동준 on 12/24/25
//

struct GameParticipantsResponse: Decodable {
    let userInfo: [GameParticipantResponse]?
}

struct GameParticipantResponse: Decodable {
    let userId: Int?
    let nickname: String?
    let combo: Int?
    let participantDays: Int?
    let participantNumbers: Int?
}
