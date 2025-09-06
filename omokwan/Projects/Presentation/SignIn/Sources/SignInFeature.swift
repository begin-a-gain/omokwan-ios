//
//  SignInFeature.swift
//  SignIn
//
//  Created by 김동준 on 8/25/24
//

import Domain
import Base
import ComposableArchitecture

@Reducer
public struct SignInFeature {
    @Dependency(\.socialUseCase) private var socialUseCase
    @Dependency(\.accountUseCase) private var accountUseCase
    @Dependency(\.localUseCase) private var localUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        var isLoading: Bool = false
        @Shared(.userInfo) var userInfo = UserInfo()
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
        case fetchUserInfo
        case userInfoFetched(UserInfo)
        case navigateToMain
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
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
                // TODO: 카카오 에러 핸들링
                state.isLoading = false
                return .none
            case .appleButtonTapped:
                return .run { send in
                    await send(signInWithApple())
                }
            case .receiveAppleTokenSuccessfully(let token):
                return .send(.navigateToSignUp)
            case .appleLoginError(let error):
                // TODO: 애플 에러 핸들링
                return .none
            case .navigateToSignUp:
                return .none
            case .shouldSignUp:
                state.isLoading = false
                return .send(.navigateToSignUp)
            case .fetchUserInfo:
                return .run { send in
                    await send(fetchUserInfo())
                }
            case .userInfoFetched(let userInfo):
                state.isLoading = false
                setUserInfo(&state, userInfo)
                return .send(.navigateToMain)
            case .navigateToMain:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            }
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
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
            _ = localUseCase.setAccessToken(signInResult.accessToken)
            
            if signInResult.signUpComplete {
                return .fetchUserInfo
            } else {
                return .shouldSignUp
            }
        case let .failure(error):
            return .showAlert(.error(error))
        }
    }
    
    func fetchUserInfo() async -> Action {
        let response = await accountUseCase.fetchUserInfo()
        switch response {
        case .success(let userInfo):
            return .userInfoFetched(userInfo)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func setUserInfo(_ state: inout State, _ info: UserInfo) {
        state.userInfo.id = info.id
        state.userInfo.email = info.email
        state.userInfo.nickname = info.nickname
    }
}
