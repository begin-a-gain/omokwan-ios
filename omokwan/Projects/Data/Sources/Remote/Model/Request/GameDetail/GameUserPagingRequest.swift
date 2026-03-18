//
//  GameUserPagingRequest.swift
//  Data
//
//  Created by jumy on 3/18/26.
//  Copyright © 2026 begin-a-gain. All rights reserved.
//

struct GameUserPagingRequest: Encodable {
    let nickname: String?
    let cursor: String?
    let size: Int?
    
    init(
        nickname: String?,
        cursor: String?,
        size: Int?
    ) {
        self.nickname = nickname
        self.cursor = cursor
        self.size = size
    }
}
