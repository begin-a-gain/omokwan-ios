//
//  LocalUseCase.swift
//  Domain
//
//  Created by 김동준 on 7/13/25
//

import DI
import Dependencies

public struct LocalUseCase {
    public let getAccessToken: () -> String?
    public let setAccessToken: (_ accessToken: String) -> Bool
}

extension LocalUseCase: DependencyKey {
    public static var liveValue: LocalUseCase = {
        let repository: LocalRepositoryProtocol = DIContainer.shared.resolve()
        return LocalUseCase(
            getAccessToken: {
                return repository.getAccessToken()
            },
            setAccessToken: { accessToken in
                return repository.setAccessToken(accessToken)
            }
        )
    }()
}

extension DependencyValues {
    public var localUseCase: LocalUseCase {
        get { self[LocalUseCase.self] }
        set { self[LocalUseCase.self] = newValue }
    }
}
