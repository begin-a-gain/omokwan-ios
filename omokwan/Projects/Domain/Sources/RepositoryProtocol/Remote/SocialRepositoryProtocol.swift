//
//  SocialRepositoryProtocol.swift
//  Domain
//
//  Created by 김동준 on 9/18/24
//

public protocol SocialRepositoryProtocol {
    func signInWithKakao() async -> Result<String, KakaoSignInError>
    func signInWithApple() async -> Result<String, AppleSignInError>
}
