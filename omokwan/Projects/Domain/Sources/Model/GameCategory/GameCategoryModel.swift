//
//  GameCategoryModel.swift
//  Domain
//
//  Created by 김동준 on 11/30/24
//

public struct GameCategory: Hashable {
    public let code: String
    public let category: String
    public let emoji: String

    public init(code: String, category: String, emoji: String) {
        self.code = code
        self.category = category
        self.emoji = emoji
    }
}
