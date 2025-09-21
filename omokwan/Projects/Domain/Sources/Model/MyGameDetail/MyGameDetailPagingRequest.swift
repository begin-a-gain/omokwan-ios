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
    public let previousDate: String
    public let nextDate: String
    public let needNextPaging: Bool
    
    public init(
        gameID: Int,
        pageSize: Int,
        date: String,
        previousDate: String,
        nextDate: String,
        needNextPaging: Bool
    ) {
        self.gameID = gameID
        self.pageSize = pageSize
        self.date = date
        self.previousDate = previousDate
        self.nextDate = nextDate
        self.needNextPaging = needNextPaging
    }
}
