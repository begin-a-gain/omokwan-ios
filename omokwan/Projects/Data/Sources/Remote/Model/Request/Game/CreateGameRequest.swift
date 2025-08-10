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
}
