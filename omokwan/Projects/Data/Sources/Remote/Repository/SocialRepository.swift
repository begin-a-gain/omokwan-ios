//
//  SocialRepository.swift
//  Data
//
//  Created by 김동준 on 9/18/24
//

import Domain

public struct SocialRepository: SocialRepositoryProtocol {
    private let socialService: SocialService
    
    public init(socialService: SocialService) {
        self.socialService = socialService
    }
    
    @MainActor
    public func signInWithKakao() async -> Result<String, KakaoSignInError> {
        do {
            let result = try await socialService.signInWithKakao()
            guard let accessToken = result else {
                return .failure(KakaoSignInError.tokenNilError)
            }
            return .success(accessToken)
        } catch let error as RemoteKakaoSignInError {
            return .failure(KakaoSignInError.error(error))
        } catch {
            return .failure(KakaoSignInError.unKnownError)
        }
    }
    
    public func signInWithApple() async -> Result<String, AppleSignInError> {
        let result = await socialService.signInWithApple()
        switch result {
        case .success(let token):
            return .success(token)
        case .failure(let error):
            return .failure(error)
        }
    }
}
