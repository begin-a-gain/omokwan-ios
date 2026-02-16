//
//  SignUpDoneFeature.swift
//  SignUp
//
//  Created by 김동준 on 11/20/24
//

import ComposableArchitecture
import Domain
import Base
import Util

@Reducer
public struct SignUpDoneFeature {
    @Dependency(\.accountUseCase) private var accountUseCase

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
        case startButtonTapped
        case navigateToMain
        case userInfoFetched(UserInfo)
        case signInAgain(NetworkError)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                state.isLoading = true
                return .run { send in
                    await send(fetchUserInfo())
                }
            case .userInfoFetched(let userInfo):
                state.isLoading = false
                setUserInfo(&state, userInfo)
                AnalyticsManager.shared.setUserId(userInfo.nickname)
                AnalyticsManager.shared.logEvent(
                    "sign_up_done",
                    parameters: [
                        "screen_name": "회원가입완료",
                        "description": "회원가입 유저명: \(userInfo.nickname)"
                    ]
                )
                return .send(.navigateToMain)
            case .signInAgain(let networkError):
                state.isLoading = false
                // TODO: 로그인 화면에서 alert 작업
                return .none
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

private extension SignUpDoneFeature {
    func fetchUserInfo() async -> Action {
        let response = await accountUseCase.fetchUserInfo()
        switch response {
        case .success(let userInfo):
            return .userInfoFetched(userInfo)
        case .failure(let error):
            return .signInAgain(error)
        }
    }
    
    func setUserInfo(_ state: inout State, _ info: UserInfo) {
        state.userInfo = info
    }
}
