//
//  AccountRepository.swift
//  Data
//
//  Created by 김동준 on 9/15/24
//

import Domain

public struct AccountRepository: AccountRepositoryProtocol {
    private let apiService: ApiService
    
    public init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    public func postSignIn(provider: SocialSignProvider, token: String) async -> Result<SignInResult, NetworkError> {
        do {
            let response: RemoteResponseModel<SignInResponse>

            switch provider {
            case .kakao:
                let endPoint = EndPoint<RemoteResponseModel<SignInResponse>>.postSignIn(
                    provider: provider.rawValue,
                    requestBody: KakaoSignInRequest(accessToken: token)
                )
                response = try await apiService.call(endPoint)
            case .apple:
                let endPoint = EndPoint<RemoteResponseModel<SignInResponse>>.postSignIn(
                    provider: provider.rawValue,
                    requestBody: AppleSignInRequest(identityToken: token)
                )
                response = try await apiService.call(endPoint)
            }
            return .success(try SignInMapper.toSignInResult(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func postNicknameDuplicated(nickname: String) async -> Result<NicknameDuplicateValidation, NetworkError> {
        do {
            let requestBody: NicknameValidationRequest = .init(nickname: nickname)
            let endPoint = EndPoint<RemoteResponseModel<NicknameDuplicateResponse>>.postNicknameDuplicated(requestBody: requestBody)
            let response = try await apiService.call(endPoint)
            return .success(try UserMapper.toNicknameDuplicateValidation(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func putNickname(nickname: String) async -> Result<Void, NetworkError> {
        do {
            let requestBody: UpdateNicknameRequest = .init(nickname: nickname)
            let endPoint = EndPoint<RemoteResponseModel<String>>.putNickname(requestBody: requestBody)
            let _ = try await apiService.call(endPoint)
            return .success(())
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func getUserInfo() async -> Result<UserInfo, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<UserInfoResponse>>.getUserInfo()
            let response = try await apiService.call(endPoint)
            return .success(try UserMapper.toUserInfo(response.data))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func postDeletionSurvey(
        reasons: [String],
        otherReasonText: String?
    ) async -> Result<Void, NetworkError> {
        do {
            let request = DeletionSurveyRequest(
                reasons: reasons,
                otherReason: otherReasonText
            )
            let endPoint = EndPoint<RemoteResponseModel<String>>.postDeletionSurvey(requestBody: request)
            let _ = try await apiService.call(endPoint)
            return .success(())
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
    
    public func deleteUserAccount() async -> Result<Void, NetworkError> {
        do {
            let endPoint = EndPoint<EmptyResponse>.deleteUserAccount()
            let _ = try await apiService.call(endPoint)
            return .success(())
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
}
