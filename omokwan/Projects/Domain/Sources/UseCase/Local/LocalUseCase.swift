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
    public let getSignUpCompleted: () -> Bool
    public let setSignUpCompleted: (_ value: Bool) -> Void
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
            },
            getSignUpCompleted: {
                return repository.getSignUpCompleted()
            },
            setSignUpCompleted: { value in
                repository.setSignUpCompleted(value)
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
