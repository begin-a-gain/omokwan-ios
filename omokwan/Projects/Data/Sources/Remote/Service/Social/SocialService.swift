//
//  SocialService.swift
//  Data
//
//  Created by 김동준 on 9/19/24
//

import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import AuthenticationServices

public class SocialService: NSObject {
    public override init() {}
    private var appleSignDelegate: AppleSignDelegate? = nil
}

// MARK: Kakao
extension SocialService {
    @MainActor
    func signInWithKakao() async throws -> String? {
        do {
            let token: OAuthToken
            if UserApi.isKakaoTalkLoginAvailable() {
                token = try await loginWithKakaoApp()
                return token.accessToken
            } else {
                token = try await loginWithKakaoAcountThroughWeb()
                return token.accessToken
            }
        } catch let error as SdkError {
            print("kakao login error \(error)")
            throw RemoteKakaoSignInError.error(error)
        } catch let error as RemoteKakaoSignInError {
            print("kakao login error \(error)")
            throw error
        } catch {
            print("kakao login unknown error \(error)")
            throw RemoteKakaoSignInError.error(error)
        }
    }
    
    @MainActor
    func loginWithKakaoApp() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let oauthToken = oauthToken {
                    continuation.resume(returning: oauthToken)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: RemoteKakaoSignInError.unknownError)
                }
            }
        }
    }
    
    @MainActor
    func loginWithKakaoAcountThroughWeb() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let oauthToken = oauthToken {
                    continuation.resume(returning: oauthToken)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: RemoteKakaoSignInError.unknownError)
                }
            }
        }
    }
}

// MARK: Apple
extension SocialService {
    @MainActor
    func signInWithApple() async -> AppleSignResult {
        let result = await withCheckedContinuation { continuation in
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            appleSignDelegate = AppleSignDelegate(appleSignContinuation: continuation)
            controller.delegate = appleSignDelegate
            controller.performRequests()
        }
        
        appleSignDelegate = nil
        return result
    }
}
