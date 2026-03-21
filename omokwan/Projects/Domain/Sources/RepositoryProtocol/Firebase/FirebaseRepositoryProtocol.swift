//
//  FirebaseRepositoryProtocol.swift
//  Domain
//
//  Created by jumy on 3/20/26.
//

public protocol FirebaseRepositoryProtocol {
    func setupRemoteConfig() async
    func getValue(forKey key: String, type: RemoteConfigValueType) -> RemoteConfigResultData
}
