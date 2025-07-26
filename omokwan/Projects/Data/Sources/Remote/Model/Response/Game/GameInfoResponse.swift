//
//  GameInfoResponse.swift
//  Data
//
//  Created by 김동준 on 7/26/25
//

struct GameInfoResponse: Decodable {
    let matchId: Int?
    let name: String?
    let ongoingDays: Int?
    let participants: Int?
    let maxParticipants: Int?
    let completed: Bool?
    let `public`: Bool?
}
