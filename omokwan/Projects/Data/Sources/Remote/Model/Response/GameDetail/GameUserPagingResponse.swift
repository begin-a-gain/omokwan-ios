//
//  GameUserPagingResponse.swift
//  Data
//
//  Created by jumy on 3/18/26.
//

import Domain

struct GameUserPagingResponse: Decodable {
    let users: [GameDetailPagingUserResponse]?
    let nextCursor: String?
    let hasNext: Bool?
}
