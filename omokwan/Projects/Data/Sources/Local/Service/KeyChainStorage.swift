//
//  KeyChainStorage.swift
//  Data
//
//  Created by 김동준 on 7/13/25
//

import Foundation
import Security
import Util

protocol KeyChainStorageProtocol {
    func save<T: KeyChainStorable>(key: String, value: T) throws
    func read<T: KeyChainStorable>(key: String, type: T.Type) throws -> T
    func update<T: KeyChainStorable>(key: String, value: T) throws
    func delete(key: String) throws
}

public final class KeyChainStorage: KeyChainStorageProtocol {
    public init() {}
    
    func save<T: KeyChainStorable>(key: String, value: T) throws {
        guard let data = value.toData() else {
            let error = KeyChainStorageError.dataConversionFailed
            OLogger.error.log(error.descrption)
            throw error
        }

        let query = baseQuery(key)
        query[kSecValueData] = data
        
        SecItemDelete(query)

        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else {
            let error = KeyChainStorageError.unExpectedStatus(status)
            OLogger.error.log(error.descrption)
            throw error
        }
    }
    
    func read<T: KeyChainStorable>(key: String, type: T.Type) throws -> T {
        let query = baseQuery(key)
        query[kSecReturnData] = true
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                let error = KeyChainStorageError.noMatchKeyError
                OLogger.error.log(error.descrption)
                throw error
            }
            
            let error = KeyChainStorageError.unExpectedStatus(status)
            OLogger.error.log(error.descrption)
            throw error
        }
        
        guard let retrievedData = dataTypeRef as? Data,
              let value = T.fromData(retrievedData) else {
            let error = KeyChainStorageError.dataConversionFailed
            OLogger.error.log(error.descrption)
            throw error
        }
        
        return value
    }
    
    func update<T: KeyChainStorable>(key: String, value: T) throws {
        try save(key: key, value: value)
    }
    
    func delete(key: String) throws {
        let query = baseQuery(key)
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                let error = KeyChainStorageError.noMatchKeyError
                OLogger.error.log(error.descrption)
                throw error
            }
            
            let error = KeyChainStorageError.unExpectedStatus(status)
            OLogger.error.log(error.descrption)
            throw error
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
