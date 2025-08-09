//
//  CreateGameRequest.swift
//  Data
//
//  Created by 김동준 on 7/27/25
//

import Foundation

struct CreateGameRequest: Encodable {
    let name: String
    let dayType: [Int]
    let maxParticipants: Int
    let categoryCode: String
    let password: String?
    let isPublic: Bool
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(dayType, forKey: .dayType)
        try container.encode(maxParticipants, forKey: .maxParticipants)
        try container.encode(categoryCode, forKey: .categoryCode)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encode(isPublic, forKey: .isPublic)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, dayType, maxParticipants, categoryCode, password, isPublic
    }

}
