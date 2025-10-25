//
//  GameRoomInformationRequestModel.swift
//  Domain
//
//  Created by 김동준 on 10/25/25
//

public struct GameRoomInformationRequestModel {
    public let joinable: Bool
    public let category: GameCategory?
    public let search: String?
    public let pageNumber: Int
    public let pageSize: Int
    
    public init(
        joinable: Bool,
        category: GameCategory?,
        search: String?,
        pageNumber: Int,
        pageSize: Int = 10
    ) {
        self.joinable = joinable
        self.category = category
        self.search = search
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }
}
