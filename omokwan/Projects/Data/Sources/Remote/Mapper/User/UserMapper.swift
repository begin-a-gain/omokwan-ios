//
//  UserMapper.swift
//  Data
//
//  Created by 김동준 on 7/19/25
//

import Domain

struct UserMapper {
    static func toUserInfo(_ response: UserInfoResponse?) throws -> UserInfo {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }
        
        return UserInfo(
            id: response.id ?? -1,
            email: response.email ?? "-",
            nickname: response.nickname ?? "-"
        )
    }
    
    static func toNicknameDuplicateValidation(_ response: NicknameDuplicateResponse?) throws -> NicknameDuplicateValidation {
        guard let response = response else {
            throw RemoteNetworkError.responseDataNilError
        }

        return NicknameDuplicateValidation(
            isValid: response.isValid ?? false,
            isDuplicated: response.isDuplicated ?? false
        )
    }
}
