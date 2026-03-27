//
//  SplashFeature.swift
//  Splash
//
//  Created by 김동준 on 9/5/25
//

import ComposableArchitecture
import Domain
import Base
import Foundation

@Reducer
public struct SplashFeature {
    @Dependency(\.accountUseCase) private var accountUseCase
    @Dependency(\.serverUseCase) private var serverUseCase
    @Dependency(\.localUseCase) private var localUseCase
    @Dependency(\.firebaseUseCase) private var firebaseUseCase
    @Dependency(\.permissionUseCase) private var permissionUseCase
    @Dependency(\.analyticsUseCase) private var analyticsUseCase

    public init() {}
    
    @ObservableState
    public struct State {
        public init() {}

        public enum AlertCase: Equatable {
            case error(NetworkError)
            case forceUpdate
            case notice(NoticePopupInfo)
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
        case setupRemoteConfig
        case checkForceUpdate
        case checkNotice
        case noticeConfirmButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                analyticsUseCase.track(.appEntry)
                state.isLoading = true
                return .concatenate([
                    .run { send in
                        try? await Task.sleep(for: .seconds(1.0))
                    },
                    .merge([
                        .send(.checkAppTrackingPermission),
                        .send(.setupRemoteConfig)
                    ])
                ])
            case .checkAppTrackingPermission:
                let needTrackingAuthorization = permissionUseCase.needTrackingAuthorization()
                if needTrackingAuthorization {
                    return .run { send in
                        let isAuthorized = await permissionUseCase.requestTrackingAuthorizationAndCheckAuthorized()
                        await send(.setTrackingValueForAnalytics(isAuthorized))
                    }
                } else {
                    let isAuthorized = permissionUseCase.isTrackingAuthorized()
                    return .send(.setTrackingValueForAnalytics(isAuthorized))
                }
            case .setTrackingValueForAnalytics(let isAuthorized):
                analyticsUseCase.setAnalyticsEnabled(isAuthorized)
                return .none
            case .setupRemoteConfig:
                return .run { send in
                    await firebaseUseCase.setupRemoteConfig()
                    await send(.checkForceUpdate)
                }
            case .checkForceUpdate:
                let forceUpdateValue = firebaseUseCase.getValue(RemoteConfigKeys.forceUpdate.rawValue, .bool)
                
                guard case let .bool(needForceUpdate) = forceUpdateValue else {
                    return .send(.showAlert(.error(.unKnownError)))
                }
                
                return needForceUpdate
                    ? .send(.showAlert(.forceUpdate))
                    : .send(.checkNotice)
            case .checkNotice:
                let noticeValue = firebaseUseCase.getValue(RemoteConfigKeys.notice.rawValue, .string)
                
                guard case let .string(noticeString) = noticeValue else {
                    return .send(.showAlert(.error(.unKnownError)))
                }
                
                guard let notice = decodeNoticePopupInfo(noticeString), !notice.isEmpty else {
                    return .send(.healthCheck)
                }
                
                return .send(.showAlert(.notice(notice)))
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
                analyticsUseCase.setUserId(userInfo.nickname)
                analyticsUseCase.track(.autoSignInSuccess)
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
            case .noticeConfirmButtonTapped:
                return .concatenate([
                    .send(.alertAction(.dismiss)),
                    .send(.healthCheck)
                ])
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
    
    func decodeNoticePopupInfo(_ noticeString: String) -> NoticePopupInfo? {
        guard let data = noticeString.data(using: .utf8) else {
            return nil
        }
        
        return try? JSONDecoder().decode(NoticePopupInfo.self, from: data)
    }
}
