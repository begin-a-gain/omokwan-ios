//
//  SignInFeature.swift
//  SignIn
//
//  Created by 김동준 on 8/25/24
//

import Domain
import Base
import ComposableArchitecture

public struct SignInFeature: Reducer {
    @Dependency(\.socialUseCase) var socialUseCase
    @Dependency(\.serverUseCase) var serverUseCase
    @Dependency(\.accountUseCase) var accountUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        var isLoading: Bool = false
    }
    
    public enum Action {
        case kakaoButtonTapped
        case receiveKakaoTokenSuccessfully(String)
        case kakaoLoginError(KakaoSignInError)
        case appleButtonTapped
        case receiveAppleTokenSuccessfully(String)
        case appleLoginError(AppleSignInError)
        case navigateToSignUp
        case shouldSignUp
        case noAction
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .kakaoButtonTapped:
                state.isLoading = true
                return .run { send in
                    await send(signInWithKakao())
                }
            case .receiveKakaoTokenSuccessfully(let token):
                return .run { send in
                    await send(
                        signIn(provider: .kakao, accessToken: token)
                    )
                }
            case .kakaoLoginError(let error):
                // TODO: 에러 핸들링
                state.isLoading = false
                return .none
            case .appleButtonTapped:
                return .run { send in
                    await send(signInWithApple())
                }
            case .receiveAppleTokenSuccessfully(let token):
                return .send(.navigateToSignUp)
            case .appleLoginError(let error):
                // TODO: 에러 핸들링
                return .none
            case .navigateToSignUp:
                return .none
            case .shouldSignUp:
                state.isLoading = false
                return .send(.navigateToSignUp)
            case .noAction:
                // TODO: 추후 제거 액션
                state.isLoading = false
                return .none
            }
        }
    }
}

private extension SignInFeature {
    func signInWithKakao() async -> Action {
        let response = await socialUseCase.signInWithKakao()
        switch response {
        case let .success(result):
            return .receiveKakaoTokenSuccessfully(result)
        case let .failure(error):
            return .kakaoLoginError(error)
        }
    }
    
    func signInWithApple() async -> Action {
        let response = await socialUseCase.signInWithApple()
        switch response {
        case let .success(result):
            return .receiveAppleTokenSuccessfully(result)
        case let .failure(error):
            return .appleLoginError(error)
        }
    }
    
    func signIn(provider: SocialSignProvider, accessToken: String) async -> Action {
        let response = await accountUseCase.signIn(provider, accessToken)
        switch response {
        case let .success(signInResult):
            if signInResult.signUpComplete {
                // TODO: Main 화면 이동 + 각종 작업 처리(미리 유저 정보 뽑기 등)
                return .noAction
            } else {
                return .shouldSignUp
            }
        case let .failure(error):
            // TODO: 에러 정해지면 작업
            return .noAction
        }
    }
}
