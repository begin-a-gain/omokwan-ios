//
//  AccountUseCase.swift
//  Domain
//
//  Created by 김동준 on 9/15/24
//

import DI
import Dependencies

public struct AccountUseCase {
    public let signIn: (_ provider: SocialSignProvider, _ token: String) async -> Result<SignInResult, NetworkError>
    public let checkNicknameDuplicated: (_ nickname: String) async -> Result<NicknameDuplicateValidation, NetworkError>
    public let updateNickname: (_ nickname: String) async -> Result<Void, NetworkError>
    public let fetchUserInfo: () async -> Result<UserInfo, NetworkError>
    public let sendDeletionSurvey: (_ reasons: [String], _ otherReasonText: String?) async -> Result<Void, NetworkError>
    public let deleteUserAccount: () async -> Result<Void, NetworkError>
}

extension AccountUseCase: DependencyKey {
    public static var liveValue: AccountUseCase = {
        let repository: AccountRepositoryProtocol = DIContainer.shared.resolve()
        return AccountUseCase(
            signIn: { provider, token in
                await repository.postSignIn(
                    provider: provider,
                    token: token
                )
            },
            checkNicknameDuplicated: { nickname in
                await repository.postNicknameDuplicated(nickname: nickname)
            },
            updateNickname: { nickname in
                await repository.putNickname(nickname: nickname)
            },
            fetchUserInfo: {
                await repository.getUserInfo()
            },
            sendDeletionSurvey: { reasons, otherReasonText in
                await repository.postDeletionSurvey(reasons: reasons, otherReasonText: otherReasonText)
            },
            deleteUserAccount: {
                await repository.deleteUserAccount()
            }
        )
    }()
}

extension AccountUseCase {
    public static let mockValue: AccountUseCase = .init(
        signIn: { provider, accessToken in
            return .success(AccountFixtures.successResult)
        },
        checkNicknameDuplicated: { nickname in
            if ["admin", "tester", "dongjun"].contains(nickname.lowercased()) {
                return .success(AccountFixtures.nicknameValid)
            } else {
                return .success(AccountFixtures.nicknameDuplicatedAndValid)
            }
        },
        updateNickname: { nickname in
            guard nickname.count >= 2 else {
                return .failure(.clientError)
            }
            return .success(())
        },
        fetchUserInfo: {
            return .success(.init())
        },
        sendDeletionSurvey: { reasons, otherReasonText in
            return .success(())
        },
        deleteUserAccount: {
            return .success(())
        }
    )
}

extension DependencyValues {
    public var accountUseCase: AccountUseCase {
        get { self[AccountUseCase.self] }
        set { self[AccountUseCase.self] = newValue }
    }
}
