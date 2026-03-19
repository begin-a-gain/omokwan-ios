//
//  GameDetailSettingRequestDTO.swift
//  Domain
//
//  Created by jumy on 3/12/26.
//  Copyright © 2026 begin-a-gain. All rights reserved.
//

public struct GameDetailSettingRequestDTO: Encodable {
    public let name: String
    public let maxParticipants: Int
    public let category: String
    public let password: String?
    public let isPublic: Bool
    
    public init(
        name: String,
        maxParticipants: Int,
        category: String,
        password: String?,
        isPublic: Bool
    ) {
        self.name = name
        self.maxParticipants = maxParticipants
        self.category = category
        self.password = password
        self.isPublic = isPublic
    }
}
