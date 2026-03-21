//
//  GameFixtures.swift
//  Domain
//
//  Created by 김동준 on 2/10/26
//

public enum GameFixtures {
    public static let gameCategories: [GameCategory] = [
        
    ]
}

public extension GameFixtures {
    static let myGameModelList: [MyGameModel] = [
        
    ]
    
    static let detailInfo: MyGameDetailInfo = .init(
        users: [],
        dates: [],
        previousDateCursor: "",
        nextDateCursor: "",
        needNextDatePaging: false,
        needPreviousDatePaging: false,
        isTodayCompleted: false
    )
    
    static let roomInfo: GameRoomInfo = .init(
        gameRoomInformation: [],
        hasNext: false
    )
}

public extension GameFixtures {
    static let detailUserInfo: DetailUserInfo = .init(
        nickname: "테스트 닉네임",
        combo: 10000,
        stones: 1000,
        participantDays: 1,
        isHost: true
    )
}

public extension GameFixtures {
    static let omokStoneStatus: OmokStoneStatus = .completed
}

public extension GameFixtures {
    static let detailSetting: GameDetailSettingConfiguration = .init()
}
