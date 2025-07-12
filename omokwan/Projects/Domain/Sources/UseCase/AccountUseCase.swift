//
//  AccountUseCase.swift
//  Domain
//
//  Created by 김동준 on 9/15/24
//

import DI
import Dependencies

public struct AccountUseCase {
    public let signIn: (_ provider: SocialSignProvider, _ accessToken: String) async -> Result<SignInResult, NetworkError>
}

extension AccountUseCase: DependencyKey {
    public static var liveValue: AccountUseCase = {
        let repository: AccountRepositoryProtocol = DIContainer.shared.resolve()
        return AccountUseCase(
            signIn: { provider, accessToken in
                await repository.postSignIn(
                    provider: provider.rawValue,
                    accessToken: accessToken
                )
            }
        )
    }()
}

extension DependencyValues {
    public var accountUseCase: AccountUseCase {
        get { self[AccountUseCase.self] }
        set { self[AccountUseCase.self] = newValue }
    }
}
