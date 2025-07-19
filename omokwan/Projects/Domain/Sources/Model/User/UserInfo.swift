//
//  UserInfo.swift
//  Domain
//
//  Created by 김동준 on 7/19/25
//

public struct UserInfo {
    public let id: Int
    public let email: String
    public let nickname: String
    
    public init(
        id: Int,
        email: String,
        nickname: String
    ) {
        self.id = id
        self.email = email
        self.nickname = nickname
    }
}
