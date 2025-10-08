//
//  MyGameDetailInfo.swift
//  Domain
//
//  Created by 김동준 on 9/7/25
//

public struct MyGameDetailInfo {
    public let users: [GameUserInfo]
    public let dates: [GameDetailDate]
    public let previousDateCursor: String
    public let nextDateCursor: String
    public let needNextDatePaging: Bool
    public let needPreviousDatePaging: Bool
    
    public init(
        users: [GameUserInfo],
        dates: [GameDetailDate],
        previousDateCursor: String,
        nextDateCursor: String,
        needNextDatePaging: Bool,
        needPreviousDatePaging: Bool
    ) {
        self.users = users
        self.dates = dates
        self.previousDateCursor = previousDateCursor
        self.nextDateCursor = nextDateCursor
        self.needNextDatePaging = needNextDatePaging
        self.needPreviousDatePaging = needPreviousDatePaging
    }
}

public struct GameUserInfo: Equatable {
    public let userID: Int
    public let nickname: String
    public let isHost: Bool
    
    public init(
        userID: Int,
        nickname: String,
        isHost: Bool
    ) {
        self.userID = userID
        self.nickname = nickname
        self.isHost = isHost
    }
}

public struct GameDetailDate: Hashable {
    public var originalDate: String
    public var date: String
    public var userStatus: [GameDetailUserStatus?]
    
    public init(
        originalDate: String,
        date: String,
        userStatus: [GameDetailUserStatus]
    ) {
        self.originalDate = originalDate
        self.date = date
        self.userStatus = userStatus
    }
}

public struct GameDetailUserStatus: Hashable {
    public let userID: Int
    public let isCompleted: Bool
    public let streakCount: Int
    public let isCombo: Bool
    
    public init(
        userID: Int,
        isCompleted: Bool,
        streakCount: Int,
        isCombo: Bool
    ) {
        self.userID = userID
        self.isCompleted = isCompleted
        self.streakCount = streakCount
        self.isCombo = isCombo
    }
}
