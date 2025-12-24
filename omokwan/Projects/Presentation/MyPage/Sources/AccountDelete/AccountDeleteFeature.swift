//
//  AccountDeleteFeature.swift
//  MyPage
//
//  Created by 김동준 on 11/24/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct AccountDeleteFeature {
    @Dependency(\.accountUseCase) private var accountUseCase
    
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case deleteCompleted
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        @Shared(.userInfo) var userInfo = UserInfo()
        @BindingState var otherReasonText: String = ""
        var isLoading: Bool = false
        var selectedReasons: [AccountDeleteReason] = []
        var orderedSelectedReasons: [AccountDeleteReason] {
            AccountDeleteReason.allCases.filter { selectedReasons.contains($0) }
        }
        var isOtherSelected: Bool {
            selectedReasons.contains(.other)
        }
        
        var isBottomButtonEnabled: Bool {
            let countValidation = selectedReasons.count > 0
            
            return countValidation && otherReasonValidation
        }
        
        var otherReasonValidation: Bool {
            if !selectedReasons.contains(.other) {
                return true
            }
            
            return !otherReasonText.isEmpty
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case reasonToggled(AccountDeleteReason)
        case deleteAccountButtonTapped
        case deleteCompleted
        case deleteAccountAlertButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .binding:
                return .none
            case .alertAction:
                return .none
            case .navigateToBack:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case let .reasonToggled(reason):
                if state.selectedReasons.contains(reason) {
                    state.selectedReasons.removeAll { $0 == reason }
                } else {
                    state.selectedReasons.append(reason)
                }
                return .none
            case .deleteAccountButtonTapped:
                state.isLoading = true
                let reasons = state.orderedSelectedReasons
                let otherText: String? = if reasons.contains(.other) {
                    state.otherReasonText
                } else {
                    nil
                }
                
                return .run { send in
                    await send(deleteAccount(reasons: reasons, otherText: otherText))
                }
            case .deleteCompleted:
                state.isLoading = false
                return .send(.showAlert(.deleteCompleted))
            case .deleteAccountAlertButtonTapped:
                return .none
            }
        }
    }
}

private extension AccountDeleteFeature {
    func deleteAccount(reasons: [AccountDeleteReason], otherText: String?) async -> Action {
        let requestReasons = reasons.map { $0.code }
        let response = await accountUseCase.deleteAccount(requestReasons, otherText)
        
        switch response {
        case .success:
            return .deleteCompleted
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}
