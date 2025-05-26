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
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase {
            case password
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        @BindingState var gameName: String = ""
        var maxNumOfPeople: Int = 5
        var selectedCategory: GameCategory?
        var privateRoomPassword: String?
        @BindingState var isPrivateRoomSelected: Bool = false
        let isHost: Bool = true
        @PresentationState var maxPeopleCountSheet: MaxPeopleCountFeature.State?
        @PresentationState var gameCategorySelectSheet: GameCategorySelectFeature.State?
        
        @BindingState var thousandsPlace: String = ""
        @BindingState var hundredsPlace: String = ""
        @BindingState var tensPlace: String = ""
        @BindingState var onesPlace: String = ""
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
        case maxNumOfPeopleButtonTapped
        case gameCategorySettingButtonTapped
        case privateRoomCodeButtonTapped
        case privateRoomToggleButtonTapped
        case inviteButtonTapped
        case hostChangeButtonTapped
        case exitButtonTapped
        case maxPeopleCountSheet(PresentationAction<MaxPeopleCountFeature.Action>)
        case gameCategorySelectSheet(PresentationAction<GameCategorySelectFeature.Action>)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case passwordAlertConfirmButtonTapped
        case passwordRefresh
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .navigateToBack:
                return .none
            case .binding:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .maxNumOfPeopleButtonTapped:
                state.maxPeopleCountSheet = .init(selectedMaxNumOfPeopleCount: state.maxNumOfPeople)
                return .none
            case .gameCategorySettingButtonTapped:
                state.gameCategorySelectSheet = .init(selectedCategory: state.selectedCategory)
                return .none
            case .gameCategorySelectSheet(let sheetAction):
                switch sheetAction {
                case .presented(let presentAction):
                    switch presentAction {
                    case .selectButtonTapped(let value):
                        state.gameCategorySelectSheet = nil
                        state.selectedCategory = value
                        return .none
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case .privateRoomCodeButtonTapped:
                if let _ = state.privateRoomPassword {
                    if state.isPrivateRoomSelected {
                        return .send(.showAlert(.password))
                    }
                }
                
                return .none
            case .privateRoomToggleButtonTapped:
                if state.isPrivateRoomSelected {
                    state.isPrivateRoomSelected = false
                } else {
                    if let _ = state.privateRoomPassword {
                        state.isPrivateRoomSelected = true
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
            case .maxPeopleCountSheet(let sheetAction):
                switch sheetAction {
                case .presented(let presentAction):
                    switch presentAction {
                    case .selectButtonTapped(let value):
                        state.maxPeopleCountSheet = nil
                        state.maxNumOfPeople = value
                        return .none
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case .passwordAlertConfirmButtonTapped:
                guard let thousands = Int(state.thousandsPlace),
                      let hundreds = Int(state.hundredsPlace),
                      let tens = Int(state.tensPlace),
                      let ones = Int(state.onesPlace)
                else { return .none }
                
                let password = (1000 * thousands) + (100 * hundreds) + (10 * tens) + ones
                state.privateRoomPassword = String(password)
                state.isPrivateRoomSelected = true
                
                return .send(.alertAction(.dismiss))
            case .passwordRefresh:
                state.thousandsPlace = ""
                state.hundredsPlace = ""
                state.tensPlace = ""
                state.onesPlace = ""
                return .none
            }
        }
        .ifLet(\.$maxPeopleCountSheet, action: \.maxPeopleCountSheet) {
            MaxPeopleCountFeature()
        }
        .ifLet(\.$gameCategorySelectSheet, action: \.gameCategorySelectSheet) {
            GameCategorySelectFeature()
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
    }
}
