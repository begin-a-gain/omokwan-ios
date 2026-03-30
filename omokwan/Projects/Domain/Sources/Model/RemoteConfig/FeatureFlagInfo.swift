//
//  FeatureFlagInfo.swift
//  Domain
//
//  Created by jumy on 4/8/26.
//

public struct FeatureFlagInfo: Decodable, Equatable {
    public let notificationFlag: Bool

    public init(notificationFlag: Bool = false) {
        self.notificationFlag = notificationFlag
    }
}
