//
//  GameUserPagingInfo.swift
//  Domain
//
//  Created by jumy on 3/18/26.
//

public struct GameUserPagingInfo: Equatable {
    public let users: [GameUserInfo]
    public let nextCursor: String
    public let hasNext: Bool
    
    public init(
        users: [GameUserInfo],
        nextCursor: String,
        hasNext: Bool
    ) {
        self.users = users
        self.nextCursor = nextCursor
        self.hasNext = hasNext
    }
}
