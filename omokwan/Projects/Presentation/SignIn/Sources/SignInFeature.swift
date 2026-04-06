//
//  SignInFeature.swift
//  SignIn
//
//  Created by 김동준 on 8/25/24
//

import Domain
import Base
import ComposableArchitecture
import Util

@Reducer
public struct SignInFeature {
    @Dependency(\.socialUseCase) private var socialUseCase
    @Dependency(\.accountUseCase) private var accountUseCase
    @Dependency(\.localUseCase) private var localUseCase
    @Dependency(\.firebaseUseCase) private var firebaseUseCase
    @Dependency(\.analyticsUseCase) private var analyticsUseCase

    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case password
            case passwordError
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        var isLoading: Bool = false
        var splashLogoTapCount: Int = 0
        let guestLoginTriggeredCount: Int = 20
        var isGuestLoginEnabled: Bool = false
        var thousandsPlace: String = ""
        var hundredsPlace: String = ""
        var tensPlace: String = ""
        var onesPlace: String = ""
        @Shared(.userInfo) var userInfo = UserInfo()
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case splashLogoTapped
        case guestLoginTriggered
        case passwordAlertCancelButtonTapped
        case passwordAlertConfirmButtonTapped
        case kakaoButtonTapped
        case receiveKakaoTokenSuccessfully(String)
        case kakaoLoginError(KakaoSignInError)
        case appleButtonTapped
        case receiveAppleTokenSuccessfully(String)
        case appleLoginError(AppleSignInError)
        case navigateToSignUp(SocialSignProvider)
        case shouldSignUp(SocialSignProvider)
        case fetchUserInfo(SocialSignProvider)
        case userInfoFetched(UserInfo, SocialSignProvider)
        case navigateToMain
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                let guestLoginValue = firebaseUseCase.getValue(RemoteConfigKeys.guestLogin.rawValue, .bool)

                if case let .bool(isEnabled) = guestLoginValue {
                    state.isGuestLoginEnabled = isEnabled
                }
                return .none
            case .splashLogoTapped:
                state.splashLogoTapCount += 1

                guard state.isGuestLoginEnabled,
                      state.splashLogoTapCount >= state.guestLoginTriggeredCount else {
                    return .none
                }

                state.splashLogoTapCount = 0
                return .send(.guestLoginTriggered)
            case .guestLoginTriggered:
                return .send(.showAlert(.password))
            case .passwordAlertCancelButtonTapped:
                return .send(.alertAction(.dismiss))
            case .passwordAlertConfirmButtonTapped:
                guard let password = [
                    state.thousandsPlace,
                    state.hundredsPlace,
                    state.tensPlace,
                    state.onesPlace
                ].passwordString else { return .none }

                guard password == "7777" else {
                    return .send(.showAlert(.passwordError))
                }

                state.isLoading = true
                return .merge(
                    .send(.alertAction(.dismiss)),
                    .run { send in
                        await send(signIn(provider: .test, token: ""))
                    }
                )
            case .kakaoButtonTapped:
                state.isLoading = true
                return .run { send in
                    await send(signInWithKakao())
                }
            case .receiveKakaoTokenSuccessfully(let token):
                return .run { send in
                    await send(
                        signIn(provider: .kakao, token: token)
                    )
                }
            case .kakaoLoginError(let error):
                // TODO: 카카오 에러 핸들링
                state.isLoading = false
                return .none
            case .appleButtonTapped:
                state.isLoading = true
                return .run { send in
                    await send(signInWithApple())
                }
            case .receiveAppleTokenSuccessfully(let token):
                return .run { send in
                    await send(
                        signIn(provider: .apple, token: token)
                    )
                }
            case .appleLoginError(let error):
                // TODO: 애플 에러 핸들링
                state.isLoading = false
                return .none
            case .navigateToSignUp:
                return .none
            case .shouldSignUp(let provider):
                state.isLoading = false
                return .send(.navigateToSignUp(provider))
            case .fetchUserInfo(let provider):
                return .run { send in
                    await send(fetchUserInfo(provider))
                }
            case let .userInfoFetched(userInfo, provider):
                state.isLoading = false
                setUserInfo(&state, userInfo)
                analyticsUseCase.track(.signInSuccess(provider: provider.rawValue))
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
    
    func signIn(provider: SocialSignProvider, token: String) async -> Action {
        let response = await accountUseCase.signIn(provider, token)
        switch response {
        case let .success(signInResult):
            _ = localUseCase.setAccessToken(signInResult.accessToken)
            localUseCase.setSignUpCompleted(signInResult.signUpComplete)
            
            if signInResult.signUpComplete {
                return .fetchUserInfo(provider)
            } else {
                return .shouldSignUp(provider)
            }
        case let .failure(error):
            return .showAlert(.error(error))
        }
    }
    
    func fetchUserInfo(_ provider: SocialSignProvider) async -> Action {
        let response = await accountUseCase.fetchUserInfo()
        switch response {
        case .success(let userInfo):
            return .userInfoFetched(userInfo, provider)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func setUserInfo(_ state: inout State, _ info: UserInfo) {
        state.$userInfo.withLock { $0 = info }
        analyticsUseCase.setUserId(state.userInfo.nickname)
    }
}
