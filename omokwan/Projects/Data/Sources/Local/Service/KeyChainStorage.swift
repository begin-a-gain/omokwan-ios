//
//  KeyChainStorage.swift
//  Data
//
//  Created by 김동준 on 7/13/25
//

import Foundation
import Security

protocol KeyChainStorageProtocol {
    func save(key: String, data: String) throws
    func read(key: String) throws -> String
    func update(key: String, data: String) throws
    func delete(key: String) throws
}

public final class KeyChainStorage: KeyChainStorageProtocol {
    public init() {}
    
    func save(key: String, data: String) throws {
        let query = baseQuery(key)
        query[kSecValueData] = data.data(using: .utf8, allowLossyConversion: false) as Any
        
        SecItemDelete(query)

        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else {
            throw KeyChainStorageError.unExpectedStatus(status)
        }
    }
    
    func read(key: String) throws -> String {
        let query = baseQuery(key)
        query[kSecReturnData] = true
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeyChainStorageError.noMatchKeyError
            }
            
            throw KeyChainStorageError.unExpectedStatus(status)
        }
        
        guard let retrievedData = dataTypeRef as? Data,
              let value = String(data: retrievedData, encoding: String.Encoding.utf8) else {
            throw KeyChainStorageError.dataConversionFailed
        }
        
        return value
    }
    
    func update(key: String, data: String) throws {
        try delete(key: key)
        try save(key: key, data: data)
    }
    
    func delete(key: String) throws {
        let query = baseQuery(key)
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeyChainStorageError.noMatchKeyError
            }
            
            throw KeyChainStorageError.unExpectedStatus(status)
        }
    }
}

private extension KeyChainStorage {
    func baseQuery(_ key: String) -> NSMutableDictionary {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
    }
}

extension KeyChainStorage: TokenProvider {
    public func getAccessToken() -> String {
        return (try? read(key: KeyChainStorageKeys.ACCESS_TOKEN)) ?? ""
    }
    
    public func setAccessToken(_ accessToken: String) {
        try? save(key: KeyChainStorageKeys.ACCESS_TOKEN, data: accessToken)
    }
    
    public func getRefreshToken() -> String {
        return (try? read(key: KeyChainStorageKeys.REFRESH_TOKEN)) ?? ""
    }
    
    public func setRefreshToken(_ refreshToken: String) {
        try? save(key: KeyChainStorageKeys.REFRESH_TOKEN, data: refreshToken)
    }
}
