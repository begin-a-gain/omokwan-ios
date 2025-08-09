//
//  GameCategoryModel.swift
//  Domain
//
//  Created by 김동준 on 11/30/24
//

public struct GameCategory {
    public let code: String
    public let category: String

    public init(code: String, category: String) {
        self.code = code
        self.category = category
    }
}
