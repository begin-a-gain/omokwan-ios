//
//  GameDetailSettingFeature.swift
//  GameDetail
//
//  Created by 김동준 on 5/17/25
//

import ComposableArchitecture
import Domain
import Foundation
import Util
import Base

@Reducer
public struct GameDetailSettingFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case password
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        
        @BindingState var gameName: String = ""
        var gameNameValidStatus: GameNameValidStatus?

        var maxNumOfPeople: Int = 5
        var selectedCategory: GameCategory?
        var categories: [GameCategory] = []
        
        var privateRoomPassword: String?
        var isPrivateRoom: Bool = false
        @BindingState var thousandsPlace: String = ""
        @BindingState var hundredsPlace: String = ""
        @BindingState var tensPlace: String = ""
        @BindingState var onesPlace: String = ""

        let isHost: Bool = false
        
        @PresentationState var maxNumOfPeopleSheet: CommonMaxNumOfPeopleFeature.State?
        @PresentationState var categorySheet: CommonCategoryFeature.State?
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case binding(BindingAction<State>)
        case maxNumOfPeopleButtonTapped
        case gameCategorySettingButtonTapped
        case privateRoomCodeButtonTapped
        case privateRoomButtonAction
        case privateRoomToggleButtonTapped
        case inviteButtonTapped
        case hostChangeButtonTapped
        case exitButtonTapped
        case categoriesFetched([GameCategory])
        case maxNumOfPeopleSheet(PresentationAction<CommonMaxNumOfPeopleFeature.Action>)
        case categorySheet(PresentationAction<CommonCategoryFeature.Action>)
        case passwordAlertConfirmButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                
                return .run { send in
                    await send(fetchCategories())
                }
            case .navigateToBack:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .binding(\.$gameName):
                if state.gameName.isEmpty {
                    state.gameNameValidStatus = .empty
                    return .none
                }
                
                let isValid = state.gameName.checkRegexValidation(
                    pattern: RegexPattern.gameName.regex
                )
                
                state.gameNameValidStatus = isValid ? .valid : .inValidFormat
                return .none
            case .binding:
                return .none
            case .maxNumOfPeopleButtonTapped:
                state.maxNumOfPeopleSheet = .init(selectedMaxNumOfPeopleCount: state.maxNumOfPeople)
                return .none
            case .privateRoomCodeButtonTapped:
                if let _ = state.privateRoomPassword {
                    if state.isPrivateRoom {
                        return .send(.showAlert(.password))
                    }
                }
                
                return .none
            case .privateRoomButtonAction:
                if state.isHost {
                    return .send(.privateRoomToggleButtonTapped)
                } else {
                    if state.isPrivateRoom {
                        // TODO: 클립보드에 복사됐습니다 토스트
                    }
                    return .none
                }
            case .privateRoomToggleButtonTapped:
                if state.isPrivateRoom {
                    state.isPrivateRoom = false
                } else {
                    if let _ = state.privateRoomPassword {
                        state.isPrivateRoom = true
                    } else {
                        return .send(.showAlert(.password))
                    }
                }
                return .none
            case .inviteButtonTapped:
                return .none
            case .hostChangeButtonTapped:
                return .none
            case .exitButtonTapped:
                return .none
            case .maxNumOfPeopleSheet(.presented(let presentAction)):
                switch presentAction {
                case .selectButtonTapped(let value):
                    state.maxNumOfPeopleSheet = nil
                    state.maxNumOfPeople = value
                    return .none
                default:
                    return .none
                }
            case .maxNumOfPeopleSheet(.dismiss):
                return .none
            case .passwordAlertConfirmButtonTapped:
                guard let thousands = Int(state.thousandsPlace),
                      let hundreds = Int(state.hundredsPlace),
                      let tens = Int(state.tensPlace),
                      let ones = Int(state.onesPlace)
                else { return .none }
                
                let password = (1000 * thousands) + (100 * hundreds) + (10 * tens) + ones
                state.privateRoomPassword = String(password)
                state.isPrivateRoom = true
                
                return .send(.alertAction(.dismiss))
            case .categoriesFetched(let categories):
                state.isLoading = false
                state.categories = categories
                return .none
            case .gameCategorySettingButtonTapped:
                state.categorySheet = .init(
                    categories: state.categories,
                    selectedCategory: state.selectedCategory
                )
                return .none
            case .categorySheet(.presented(let presentAction)):
                switch presentAction {
                case .selectButtonTapped(let value):
                    state.categorySheet = nil
                    state.selectedCategory = value
                    return .none
                default:
                    return .none
                }
            case .categorySheet(.dismiss):
                return .none
            }
        }
        .ifLet(\.$maxNumOfPeopleSheet, action: \.maxNumOfPeopleSheet) {
            CommonMaxNumOfPeopleFeature()
        }
        .ifLet(\.$categorySheet, action: \.categorySheet) {
            CommonCategoryFeature()
        }
    }
}

private extension GameDetailSettingFeature {
    func fetchCategories() async -> Action {
        let response = await gameUseCase.fetchGameCategories()
        switch response {
        case .success(let categories):
            return .categoriesFetched(categories)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}
