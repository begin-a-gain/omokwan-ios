//
//  KeyChainStorage+Extension.swift
//  Data
//
//  Created by 김동준 on 9/6/25
//

import Foundation

extension KeyChainStorage: TokenProvider {
    public func getAccessToken() -> String {
        return (try? read(key: KeyChainStorageKeys.ACCESS_TOKEN, type: String.self)) ?? ""
    }
    
    public func setAccessToken(_ accessToken: String) {
        try? save(key: KeyChainStorageKeys.ACCESS_TOKEN, value: accessToken)
    }
    
    public func getRefreshToken() -> String {
        return (try? read(key: KeyChainStorageKeys.REFRESH_TOKEN, type: String.self)) ?? ""
    }
    
    public func setRefreshToken(_ refreshToken: String) {
        try? save(key: KeyChainStorageKeys.REFRESH_TOKEN, value: refreshToken)
    }
}
