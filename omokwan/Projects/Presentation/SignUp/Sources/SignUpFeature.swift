//
//  SignUpFeature.swift
//  SignUp
//
//  Created by 김동준 on 10/4/24
//

import Base
import ComposableArchitecture
import Foundation
import Domain
import Util

@Reducer
public struct SignUpFeature {
    @Dependency(\.accountUseCase) private var accountUseCase
    @Dependency(\.mainQueue) private var mainQueue

    public init() {}
    
    public struct State: Equatable{
        public init() {}
        
        fileprivate enum DebounceID {
            case nickname
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        enum NicknameValidStatus {
            case duplicated
            case invalidFormat
            case empty
            case valid
        }
        
        var isNextButtonEnable: Bool {
            nicknameValidStatus == .valid
        }
        @BindingState var nickname: String = ""
        var isLoading: Bool = false
        var nicknameValidStatus: NicknameValidStatus?
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case navigateToBack
        case binding(BindingAction<State>)
        case validNickname(NicknameDuplicateValidation)
        case checkNicknameValidation(String)
        case nicknameUpdateCompleted
        case navigateToSignUpDone
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.$nickname):
                let nickname = state.nickname
                
                if state.nickname.isEmpty {
                    state.nicknameValidStatus = .empty
                    return .none
                }
                
                return .run { send in
                    await send(.checkNicknameValidation(nickname))
                }
                .debounce(id: State.DebounceID.nickname, for: .milliseconds(500), scheduler: mainQueue)
            case .binding:
                return .none
            case .checkNicknameValidation(let nickname):
                guard nickname.checkRegexValidation(pattern: RegexPattern.nickname.regex) else {
                    state.nicknameValidStatus = .invalidFormat
                    return .none
                }
                
                state.isLoading = true

                return .run { send in
                    await send(checkNicknameDuplicated(nickname))
                }
            case .nextButtonTapped:
                state.isLoading = true
                let nickname = state.nickname
                return .run { send in
                    await send(updateNickname(nickname))
                }
            case .navigateToBack:
                return .none
            case .validNickname(let nicknameValidation):
                state.isLoading = false
                
                if nicknameValidation.isDuplicated {
                    state.nicknameValidStatus = .duplicated
                    return .none
                }

                state.nicknameValidStatus = nicknameValidation.isValid ? .valid : .invalidFormat
                return .none
            case .nicknameUpdateCompleted:
                state.isLoading = false
                return .send(.navigateToSignUpDone)
            case .navigateToSignUpDone:
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

private extension SignUpFeature {
    func checkNicknameDuplicated(_ nickname: String) async -> Action {
        let response = await accountUseCase.checkNicknameDuplicated(nickname)
        switch response {
        case .success(let duplicationValidation):
            return .validNickname(duplicationValidation)
        case let .failure(error):
            return .showAlert(.error(error))
        }
    }
    
    func updateNickname(_ nickname: String) async -> Action {
        let response = await accountUseCase.updateNickname(nickname)
        switch response {
        case .success:
            return .nicknameUpdateCompleted
        case let .failure(error):
            return .showAlert(.error(error))
        }
    }
}
