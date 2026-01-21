//
//  GameDetailSettingConfiguration.swift
//  Domain
//
//  Created by 김동준 on 1/19/26
//

public struct GameDetailSettingConfiguration: Equatable {
    public let title: String
    public let daysInProgress: Int
    public let code: String
    public let dayDescription: String
    public let maxNumberOfPlayers: Int
    public let categoryString: String
    public let password: String?
    public let isPublic: Bool
    
    public init(
        title: String,
        daysInProgress: Int,
        code: String,
        dayDescription: String,
        maxNumberOfPlayers: Int,
        categoryString: String,
        password: String?,
        isPublic: Bool
    ) {
        self.title = title
        self.daysInProgress = daysInProgress
        self.code = code
        self.dayDescription = dayDescription
        self.maxNumberOfPlayers = maxNumberOfPlayers
        self.categoryString = categoryString
        self.password = password
        self.isPublic = isPublic
    }
}
