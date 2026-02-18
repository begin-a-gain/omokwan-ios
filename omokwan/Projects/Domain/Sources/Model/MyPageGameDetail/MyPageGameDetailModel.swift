//
//  MyPageGameDetailModel.swift
//  Domain
//
//  Created by 김동준 on 1/14/26
//

public struct MyPageGameInfo: Equatable {
    public let userID: Int
    public let nickname: String
    public let inProgressGameCount: Int
    public let completedGameCount: Int
    public let inProgressGames: [MyPageGameDetailModel]
    public let completedGames: [MyPageGameDetailModel]
    
    public init(
        userID: Int = -1,
        nickname: String = "",
        inProgressGameCount: Int = 0,
        completedGameCount: Int = 0,
        inProgressGames: [MyPageGameDetailModel] = [],
        completedGames: [MyPageGameDetailModel] = []
    ) {
        self.userID = userID
        self.nickname = nickname
        self.inProgressGameCount = inProgressGameCount
        self.completedGameCount = completedGameCount
        self.inProgressGames = inProgressGames
        self.completedGames = completedGames
    }
}

public struct MyPageGameDetailModel: Equatable {
    public let gameID: Int
    public let title: String
    public let ongoingDays: Int
    public let combo: Int
    public let stone: Int
    public let dayDescription: String?
    
    public init(
        gameID: Int = -1,
        title: String = "-",
        ongoingDays: Int = 0,
        combo: Int = 0,
        stone: Int = 0,
        dayDescription: String? = nil
    ) {
        self.gameID = gameID
        self.title = title
        self.ongoingDays = ongoingDays
        self.combo = combo
        self.stone = stone
        self.dayDescription = dayDescription
    }
}
