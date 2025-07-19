//
//  SignUpDoneFeature.swift
//  SignUp
//
//  Created by 김동준 on 11/20/24
//

import ComposableArchitecture
import Domain

public struct SignUpDoneFeature: Reducer {
    @Dependency(\.accountUseCase) private var accountUseCase

    public init() {}
    
    public struct State: Equatable {
        var isLoading: Bool = false

        public init() {}
    }
    
    public enum Action {
        case startButtonTapped
        case navigateToMain
        case userInfoFetched(UserInfo)
        case signInAgain
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
                print("## userInfo = \(userInfo)")
                // TODO: UserManager 에 set
                return .send(.navigateToMain)
            case .signInAgain:
                state.isLoading = false
                return .none
            case .navigateToMain:
                return .none
            }
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
            return .signInAgain
        }
    }
}
