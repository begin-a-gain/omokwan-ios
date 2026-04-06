//
//  ServerUseCase.swift
//  Domain
//
//  Created by 김동준 on 6/28/25
//

import DI
import Dependencies

public struct ServerUseCase {
    public let healthCheck: () async -> Result<Bool, NetworkError>
}

extension ServerUseCase: DependencyKey {
    public static var liveValue: ServerUseCase = {
        let repository: ServerRepositoryProtocol = DIContainer.shared.resolve()
        return ServerUseCase(
            healthCheck: {
                await repository.healthCheck()
            }
        )
    }()
}

extension ServerUseCase {
    public static var mockValue: ServerUseCase = .init(
        healthCheck: {
            return .success(true)
        }
    )
}

extension DependencyValues {
    public var serverUseCase: ServerUseCase {
        get { self[ServerUseCase.self] }
        set { self[ServerUseCase.self] = newValue }
    }
}
