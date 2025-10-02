//
//  MyGameDetailPagingRequest.swift
//  Domain
//
//  Created by 김동준 on 9/7/25
//

public struct MyGameDetailPagingRequest {
    public let gameID: Int
    public var pageSize: Int
    public var date: String
    
    public init(
        gameID: Int,
        pageSize: Int,
        date: String,
    ) {
        self.gameID = gameID
        self.pageSize = pageSize
        self.date = date
    }
}
