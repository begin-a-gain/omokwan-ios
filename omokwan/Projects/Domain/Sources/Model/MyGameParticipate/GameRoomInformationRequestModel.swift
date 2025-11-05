//
//  GameRoomInformationRequestModel.swift
//  Domain
//
//  Created by 김동준 on 10/25/25
//

public struct GameRoomInformationRequestModel {
    public let joinable: Bool?
    public let categoryList: [GameCategory]?
    public let search: String?
    public let pageNumber: Int
    public let pageSize: Int
    
    public init(
        joinable: Bool?,
        categoryList: [GameCategory]?,
        search: String?,
        pageNumber: Int,
        pageSize: Int = 10
    ) {
        self.joinable = joinable
        self.categoryList = categoryList
        self.search = search
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }
}
