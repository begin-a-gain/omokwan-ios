//
//  MyGameAddConfiguration.swift
//  Domain
//
//  Created by 김동준 on 8/9/25
//

public struct MyGameAddConfiguration {
    public let name: String
    public let dayType: [Int]
    public let maxParticipants: Int
    public let categoryCode: String?
    public let password: String?
    public let isPublic: Bool
    
    public init(
        name: String,
        dayType: [Int],
        maxParticipants: Int,
        categoryCode: String?,
        password: String?,
        isPublic: Bool
    ) {
        self.name = name
        self.dayType = dayType
        self.maxParticipants = maxParticipants
        self.categoryCode = categoryCode
        self.password = password
        self.isPublic = isPublic
    }
}
