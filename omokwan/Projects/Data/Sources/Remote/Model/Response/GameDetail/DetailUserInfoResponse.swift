//
//  DetailUserInfoResponse.swift
//  Data
//
//  Created by 김동준 on 9/15/25
//

struct DetailUserInfoResponse: Decodable {
    let nickName: String?
    let combo: Int?
    let participantNumbers: Int?
    let participantDays: Int?
    let isHost: Bool?
}
