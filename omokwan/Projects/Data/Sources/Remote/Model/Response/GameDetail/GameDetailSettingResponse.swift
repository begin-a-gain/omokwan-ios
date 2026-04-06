//
//  GameDetailSettingResponse.swift
//  Data
//
//  Created by 김동준 on 1/19/26
//

struct GameDetailSettingResponse: Decodable {
    let name: String?
    let ongoingDays: Int?
    let matchCode: String?
    let repeatDayTypes: [Int?]
    let maxParticipants: Int?
    let category: String?
    let password: String?
    let isPublic: Bool?
}
