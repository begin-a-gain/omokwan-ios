//
//  GameParticipateInfoResponse.swift
//  Data
//
//  Created by 김동준 on 10/25/25
//

struct GameParticipateInfoResponse: Decodable {
    let matchId: Int?
    let categoryId: Int?
    let name: String?
    let hostName: String?
    let ongoingDays: Int?
    let participants: Int?
    let maxParticipants: Int?
    let joinable: String?
    let `public`: Bool?
}
