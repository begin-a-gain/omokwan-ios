//
//  GameDetailPagingResponse.swift
//  Data
//
//  Created by 김동준 on 9/7/25
//

import Domain

struct GameDetailPagingResponse: Decodable {
    let users: [GameDetailPagingUserResponse]?
    let dates: [GameDetailPagingDateResponse]?
    let prevCursor: String?
    let nextCursor: String?
    let hasPrev: Bool?
    let hasNext: Bool?
}

struct GameDetailPagingUserResponse: Decodable {
    let userId: Int?
    let nickname: String?
    let isHost: Bool?
}

struct GameDetailPagingDateResponse: Decodable {
    let date: String?
    let userStatus: [GameDetailPagingUserStatus]?
}

struct GameDetailPagingUserStatus: Decodable {
    let userId: Int?
    let isCompleted: Bool?
    let streakCount: Int?
    let isCombo: Bool?
}

extension GameDetailPagingUserResponse {
    func toDomain() -> GameUserInfo {
        GameUserInfo(
            userID: self.userId ?? 0,
            nickname: self.nickname ?? "",
            isHost: self.isHost ?? false
        )
    }
}

extension GameDetailPagingDateResponse {
    func toDomain() -> GameDetailDate {
        GameDetailDate(
            date: self.date ?? "",
            userStatus: self.userStatus?.map {
                $0.toDomain()
            } ?? []
        )
    }
}

extension GameDetailPagingUserStatus {
    func toDomain() -> GameDetailUserStatus {
        GameDetailUserStatus(
            userID: self.userId ?? 0,
            isCompleted: self.isCompleted ?? false,
            streakCount: self.streakCount ?? 0,
            isCombo: self.isCombo ?? false
        )
    }
}
