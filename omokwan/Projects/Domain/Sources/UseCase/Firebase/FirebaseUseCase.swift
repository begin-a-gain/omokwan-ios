//
//  FirebaseUseCase.swift
//  Domain
//
//  Created by 김동준 on 11/9/25
//

import DI
import Dependencies
import Foundation

public struct FirebaseUseCase {
    public let setupRemoteConfig: () async -> Void
    public let getValue: (_ key: String, _ type: RemoteConfigValueType) -> RemoteConfigResultData
}

extension FirebaseUseCase: DependencyKey {
    public static var liveValue: FirebaseUseCase = {
        let repository: FirebaseRepositoryProtocol = DIContainer.shared.resolve()
        
        return .init(
            setupRemoteConfig: {
                await repository.setupRemoteConfig()
            },
            getValue: { key, type in
                repository.getValue(forKey: key, type: type)
            }
        )
    }()
}

extension FirebaseUseCase {
    public static var mockValue: FirebaseUseCase = .init(
        setupRemoteConfig: {},
        getValue: { _, type in
            switch type {
            case .bool:
                return .bool(false)
            case .string:
                return .string("")
            case .int:
                return .int(0)
            case .double:
                return .double(0)
            case .data:
                return .data(Data())
            }
        }
    )
}

extension DependencyValues {
    public var firebaseUseCase: FirebaseUseCase {
        get { self[FirebaseUseCase.self] }
        set { self[FirebaseUseCase.self] = newValue }
    }
}
