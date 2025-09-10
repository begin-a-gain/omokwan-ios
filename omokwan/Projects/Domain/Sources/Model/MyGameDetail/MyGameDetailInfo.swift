//
//  MyGameDetailInfo.swift
//  Domain
//
//  Created by 김동준 on 9/7/25
//

public struct MyGameDetailInfo {
    public let users: [GameUserInfo]
    public let dates: [GameDetailDate]
    public let previousDate: String
    public let nextDate: String
    
    public init(
        users: [GameUserInfo],
        dates: [GameDetailDate],
        previousDate: String,
        nextDate: String
    ) {
        self.users = users
        self.dates = dates
        self.previousDate = previousDate
        self.nextDate = nextDate
    }
}

public struct GameUserInfo {
    public let userID: Int
    public let nickname: String
    
    public init(userID: Int, nickname: String) {
        self.userID = userID
        self.nickname = nickname
    }
}

public struct GameDetailDate {
    public let date: String
    public let userStatus: [GameDetailUserStatus]
    
    public init(
        date: String,
        userStatus: [GameDetailUserStatus]
    ) {
        self.date = date
        self.userStatus = userStatus
    }
}

public struct GameDetailUserStatus {
    public let userID: Int
    public let status: String
    public let comboLength: Int
    public let isCombo: Bool
    
    public init(
        userID: Int,
        status: String,
        comboLength: Int,
        isCombo: Bool
    ) {
        self.userID = userID
        self.status = status
        self.comboLength = comboLength
        self.isCombo = isCombo
    }
}
