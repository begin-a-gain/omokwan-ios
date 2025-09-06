//
//  LocalRepository.swift
//  Data
//
//  Created by 김동준 on 7/13/25
//

import Domain

public struct LocalRepository: LocalRepositoryProtocol {
    private let keyChainStorage: KeyChainStorage
    
    public init(keyChainStorage: KeyChainStorage) {
        self.keyChainStorage = keyChainStorage
    }
    
    public func getAccessToken() -> String? {
        return try? keyChainStorage.read(key: KeyChainStorageKeys.ACCESS_TOKEN)
    }

    public func setAccessToken(_ accessToken: String) -> Bool {
        do {
            try keyChainStorage.save(key: KeyChainStorageKeys.ACCESS_TOKEN, data: accessToken)
            return true
        } catch {
            return false
        }
    }
    
    public func getSignUpCompleted() -> Bool {
        do {
            // TODO: Bool도 받을 수 있게 KeyChainStorage 변경 필요
            return true
        } catch {
            return false
        }
    }
}
