//
//  GameDetailSettingConfiguration.swift
//  Domain
//
//  Created by 김동준 on 1/19/26
//

public struct GameDetailSettingConfiguration: Equatable {
    public var title: String
    public var daysInProgress: Int
    public var code: String
    public var dayDescription: String
    public var maxNumberOfPlayers: Int
    public var categoryCode: String
    public var password: String?
    public var isPublic: Bool
    
    public init(
        title: String = "",
        daysInProgress: Int = 0,
        code: String = "",
        dayDescription: String = "",
        maxNumberOfPlayers: Int = 0,
        categoryCode: String = "",
        password: String? = nil,
        isPublic: Bool = true
    ) {
        self.title = title
        self.daysInProgress = daysInProgress
        self.code = code
        self.dayDescription = dayDescription
        self.maxNumberOfPlayers = maxNumberOfPlayers
        self.categoryCode = categoryCode
        self.password = password
        self.isPublic = isPublic
    }
    
    public static func == (
        lhs: GameDetailSettingConfiguration,
        rhs: GameDetailSettingConfiguration
    ) -> Bool {
        guard
            lhs.title == rhs.title,
            lhs.daysInProgress == rhs.daysInProgress,
            lhs.code == rhs.code,
            lhs.dayDescription == rhs.dayDescription,
            lhs.maxNumberOfPlayers == rhs.maxNumberOfPlayers,
            lhs.categoryCode == rhs.categoryCode,
            lhs.isPublic == rhs.isPublic
        else {
            return false
        }

        if lhs.isPublic == false {
            return lhs.password == rhs.password
        } else {
            return true
        }
    }
}
