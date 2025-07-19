//
//  UserInfoResponse.swift
//  Data
//
//  Created by 김동준 on 7/19/25
//

struct UserInfoResponse: Decodable {
    let id: Int?
    let socialId: Int?
    let email: String?
    let nickname: String?
    let platform: String?
    let refreshToken: String?
    let deleted: Bool?
}
