//
//  SplashFeature.swift
//  Splash
//
//  Created by 김동준 on 9/5/25
//

import ComposableArchitecture
import Domain
import Base
import Util

@Reducer
public struct SplashFeature {
    @Dependency(\.accountUseCase) private var accountUseCase
    @Dependency(\.serverUseCase) private var serverUseCase
    @Dependency(\.localUseCase) private var localUseCase
    @Dependency(\.firebaseUseCase) private var firebaseUseCase

    public init() {}
    
    @ObservableState
    public struct State {
        public init() {}

        public enum AlertCase: Equatable {
            case error(NetworkError)
        }

        @Shared(.userInfo) var userInfo = UserInfo()
        
        var isLoading: Bool = false
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
    }
    
    public enum Action {
        case onAppear
        case navigateToMain
        case navigateToSignIn
        case userInfoFetched(UserInfo)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case userInfoFetchFailed
        case checkSignUpDone
        case checkAppTrackingPermission
        case setTrackingValueForAnalytics(Bool)
        case healthCheck
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate([
                    .run { send in
                        try? await Task.sleep(for: .seconds(1))
                    },
                    .send(.checkAppTrackingPermission)
                ])
            case .checkAppTrackingPermission:
                let needTrackingAuthorization = firebaseUseCase.needTrackingAuthorization()
                if needTrackingAuthorization {
                    return .run { send in
                        let isAuthorized = await firebaseUseCase.requestTrackingAuthorizationAndCheckAuthorized()
                        await send(.setTrackingValueForAnalytics(isAuthorized))
                    }
                } else {
                    let isAuthorized = firebaseUseCase.isTrackingAuthorized()
                    return .send(.setTrackingValueForAnalytics(isAuthorized))
                }
            case .setTrackingValueForAnalytics(let isAuthorized):
                AnalyticsManager.shared.setAnalyticsEnabled(isAuthorized)
                return .send(.healthCheck)
            case .healthCheck:
                state.isLoading = true
                return .run { send in
                    await send(checkServerHealth())
                }
            case .checkSignUpDone:
                state.isLoading = false

                let isSignUpCompleted = localUseCase.getSignUpCompleted()
                
                guard isSignUpCompleted else {
                    return .send(.navigateToSignIn)
                }
                
                state.isLoading = true
                return .run { send in
                    await send(fetchUserInfo())
                }
            case .userInfoFetched(let userInfo):
                state.isLoading = false
                setUserInfo(&state, userInfo)
                AnalyticsManager.shared.setUserId(userInfo.nickname)
                return .send(.navigateToMain)
            case .navigateToMain:
                return .none
            case .navigateToSignIn:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .userInfoFetchFailed:
                state.isLoading = false
                return .send(.navigateToSignIn)
            }
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
    }
}

private extension SplashFeature {
    func checkServerHealth() async -> Action {
        let response = await serverUseCase.healthCheck()
        switch response {
        case .success:
            return .checkSignUpDone
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func fetchUserInfo() async -> Action {
        let response = await accountUseCase.fetchUserInfo()
        switch response {
        case .success(let userInfo):
            return .userInfoFetched(userInfo)
        case .failure:
            return .userInfoFetchFailed
        }
    }
    
    func setUserInfo(_ state: inout State, _ info: UserInfo) {
        state.userInfo = info
    }
}
