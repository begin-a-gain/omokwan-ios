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

    public init() {}
    
    enum DebounceID {
        case nickname
    }
    
    public struct State: Equatable{
        public init() {}
        
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
        case validNickname
        case checkNicknameValidation(String)
        case checkNicknameDuplicated(String)
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
                if state.nickname.isEmpty {
                    state.nicknameValidStatus = .empty
                    return .none
                }
                
                let nickname = state.nickname
                return .run { send in
                    await send(.checkNicknameValidation(nickname))
                }
                .debounce(id: DebounceID.nickname, for: .milliseconds(500), scheduler: DispatchQueue.main)
            case .binding:
                return .none
            case .checkNicknameValidation(let nickname):
                let isValid = nickname.checkRegexValidation(pattern: RegexPattern.nickname.regex)
                
                if !isValid {
                    state.nicknameValidStatus = .invalidFormat
                    return .none
                }
                
                return .run { send in
                    await send(.checkNicknameDuplicated(nickname))
                }
            case .checkNicknameDuplicated(let nickname):
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
            case .validNickname:
                state.isLoading = false
                state.nicknameValidStatus = .valid
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
        case .success:
            return .validNickname
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
