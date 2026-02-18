//
//  MyPageGameInfoResponse.swift
//  Data
//
//  Created by jumy on 2/17/26.
//

import Domain

struct MyPageGameInfoResponse: Decodable {
    let userID: Int?
    let nickname: String?
    let inProgressMatchCount: Int?
    let completedMatchCount: Int?
    let inProgressMatches: [MyPageGameDetailInfoResponse]?
    let completedMatches: [MyPageGameDetailInfoResponse]?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case inProgressMatchCount
        case completedMatchCount
        case inProgressMatches
        case completedMatches
    }
}

struct MyPageGameDetailInfoResponse: Codable {
    let matchID: Int?
    let matchName: String?
    let participantDays: Int?
    let comboCount: Int?
    let participantNumbers: Int?
    let dayOfWeeks: [Int]?

    enum CodingKeys: String, CodingKey {
        case matchID = "matchId"
        case matchName
        case participantDays
        case comboCount
        case participantNumbers
        case dayOfWeeks
    }
}

extension MyPageGameInfoResponse {
    func toDomain() -> MyPageGameInfo {
        MyPageGameInfo(
            userID: self.userID ?? -1,
            nickname: self.nickname ?? "-",
            inProgressGameCount: self.inProgressMatchCount ?? 0,
            completedGameCount: self.completedMatchCount ?? 0,
            inProgressGames: self.inProgressMatches.toDomain(),
            completedGames: self.completedMatches.toDomain()
        )
    }
}

extension [MyPageGameDetailInfoResponse]? {
    func toDomain() -> [MyPageGameDetailModel] {
        guard let self = self else { return [] }
        return self.map {
            MyPageGameDetailModel(
                gameID: $0.matchID ?? -1,
                title: $0.matchName ?? "-",
                ongoingDays: $0.participantDays ?? 0,
                combo: $0.comboCount ?? 0,
                stone: $0.participantNumbers ?? 0,
                dayDescription: $0.dayOfWeeks?.toDayDescription(isSpaced: false)
            )
        }
    }
}
