//
//  UserInfo.swift
//  Domain
//
//  Created by 김동준 on 7/19/25
//

public struct UserInfo: Equatable {
    public var id: Int
    public var email: String
    public var nickname: String
    
    public init(
        id: Int = -1,
        email: String = "-",
        nickname: String = "-"
    ) {
        self.id = id
        self.email = email
        self.nickname = nickname
    }
}
