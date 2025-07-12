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
    
    public func postSignIn(provider: String, accessToken: String) async -> Result<SignInResult, NetworkError> {
        do {
            let endPoint = EndPoint<RemoteResponseModel<SignInResponse>>.postSignIn(
                provider: provider,
                requestBody: SignInRequest(accessToken: accessToken)
            )
            let result = try await apiService.call(endPoint)
            guard let response = result.data else { return .failure(.unKnownError) }
            return .success(SignInMapper.toSignInResult(response))
        } catch {
            return .failure(ErrorMapper.toNetworkError(error))
        }
    }
}
