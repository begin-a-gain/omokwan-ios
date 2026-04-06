//
//  FirebaseRepository.swift
//  Data
//
//  Created by jumy on 3/20/26.
//

import Domain

public struct FirebaseRepository: FirebaseRepositoryProtocol {
    private let firebaseService: FirebaseService
    
    public init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    public func setupRemoteConfig() async {
        await firebaseService.setupRemoteConfig()
    }
    
    public func getValue(forKey key: String, type: RemoteConfigValueType) -> RemoteConfigResultData {
        firebaseService.getValue(forKey: key, type: type)
    }
}
