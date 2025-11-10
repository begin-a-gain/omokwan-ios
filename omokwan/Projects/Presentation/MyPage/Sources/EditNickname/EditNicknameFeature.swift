//
//  EditNicknameFeature.swift
//  MyPage
//
//  Created by 김동준 on 11/3/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct EditNicknameFeature {
    @Dependency(\.accountUseCase) private var accountUseCase
    @Dependency(\.mainQueue) private var mainQueue
    
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        enum NicknameValidStatus {
            case duplicated
            case invalidFormat
            case empty
            case valid
        }
        
        fileprivate enum DebounceID {
            case defaultValidation
            case duplicate
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        @Shared(.userInfo) var userInfo = UserInfo()
        @BindingState var nickname: String = ""
        var originalNickname: String = ""
        var nicknameValidStatus: NicknameValidStatus?
        var isButtonEnabled: Bool {
            let isNicknameChanged = nickname != originalNickname
            return !nickname.isEmpty
                && nicknameValidStatus == .valid
                && isNicknameChanged
                && !isLoading
        }
        var isLoading: Bool = false
    }

    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
        case checkNicknameValidation(String)
        case checkNicknameDuplicated(String)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case validNickname(NicknameDuplicateValidation)
        case nicknameUpdateButtonTapped
        case nicknameUpdateCompleted
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.nickname = state.userInfo.nickname
                state.originalNickname = state.userInfo.nickname
                return .none
            case .binding(\.$nickname):
                let nickname = state.nickname
                
                guard !nickname.isEmpty else {
                    state.nicknameValidStatus = .empty
                    return .none
                }
                
                return .run { send in
                    await send(.checkNicknameValidation(nickname))
                }.debounce(id: State.DebounceID.defaultValidation, for: .milliseconds(200), scheduler: mainQueue)
            case .navigateToBack:
                return .none
            case .binding:
                return .none
            case .checkNicknameValidation(let nickname):
                if state.nickname == state.originalNickname {
                    state.nicknameValidStatus = .valid
                    return .none
                }
                
                state.nicknameValidStatus = nil
                
                let isValid = nickname.checkRegexValidation(pattern: RegexPattern.nickname.regex)
                
                if !isValid {
                    state.nicknameValidStatus = .invalidFormat
                    return .none
                }
                
                return .run { send in
                    await send(.checkNicknameDuplicated(nickname))
                }.debounce(id: State.DebounceID.duplicate, for: .milliseconds(500), scheduler: mainQueue)
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .checkNicknameDuplicated(let nickname):
                let isValid = nickname.checkRegexValidation(pattern: RegexPattern.nickname.regex)
                
                if !isValid {
                    state.nicknameValidStatus = .invalidFormat
                    return .none
                }
                
                state.isLoading = true
                
                return .run { send in
                    await send(checkNicknameDuplicated(nickname))
                }
            case .validNickname(let nicknameValidation):
                state.isLoading = false
                
                if nicknameValidation.isDuplicated {
                    state.nicknameValidStatus = .duplicated
                    return .none
                }
                
                if nicknameValidation.isValid {
                    state.nicknameValidStatus = .valid
                    return .none
                } else {
                    state.nicknameValidStatus = .invalidFormat
                    return .none
                }
            case .nicknameUpdateButtonTapped:
                state.isLoading = true
                
                let nickname = state.nickname
                return .run { send in
                    await send(updateNickname(nickname))
                }
            case .nicknameUpdateCompleted:
                state.isLoading = false
                state.userInfo.nickname = state.nickname
                return .none
            }
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
    }
}

private extension EditNicknameFeature {
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
