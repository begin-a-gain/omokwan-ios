//
//  MyPageGameDetailModel.swift
//  Domain
//
//  Created by 김동준 on 1/14/26
//

public struct MyPageGameDetailModel: Equatable {
    public let id: Int
    public let title: String
    public let ongoingDays: Int
    public let combo: Int
    public let stone: Int
    public let dayDescription: String?
    
    public init(
        id: Int = -1,
        title: String = "-",
        ongoingDays: Int = 0,
        combo: Int = 0,
        stone: Int = 0,
        dayDescription: String? = nil
    ) {
        self.id = id
        self.title = title
        self.ongoingDays = ongoingDays
        self.combo = combo
        self.stone = stone
        self.dayDescription = dayDescription
    }
}
