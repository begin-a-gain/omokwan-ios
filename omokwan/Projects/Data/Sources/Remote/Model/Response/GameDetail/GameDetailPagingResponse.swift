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
    let previousDate: String?
    let nextDate: String?
}

struct GameDetailPagingUserResponse: Decodable {
    let userId: Int?
    let nickname: String?
}

struct GameDetailPagingDateResponse: Decodable {
    let date: String?
    let userStatus: [GameDetailPagingUserStatus]?
}

struct GameDetailPagingUserStatus: Decodable {
    let userId: Int?
    let status: String?
    let comboLength: Int?
    let isCombo: Bool?
}

extension GameDetailPagingUserResponse {
    func toDomain() -> GameUserInfo {
        GameUserInfo(
            userID: self.userId ?? 0,
            nickname: self.nickname ?? ""
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
            status: self.status ?? "",
            comboLength: self.comboLength ?? 0,
            isCombo: self.isCombo ?? false
        )
    }
}
