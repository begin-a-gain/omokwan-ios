//
//  GameUserPagingRequest.swift
//  Data
//
//  Created by jumy on 3/18/26.
//  Copyright © 2026 begin-a-gain. All rights reserved.
//

struct GameUserPagingRequest: Encodable {
    let matchId: Int
    let nickname: String?
    let cursor: String?
    let size: Int?
    
    init(
        matchId: Int,
        nickname: String?,
        cursor: String?,
        size: Int?
    ) {
        self.matchId = matchId
        self.nickname = nickname
        self.cursor = cursor
        self.size = size
    }
}
