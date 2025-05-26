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
        
        @BindingState var gameName: String = ""
        var maxNumOfPeople: Int = 5
        var selectedCategory: GameCategory?
        var privateRoomPassword: String?
        @BindingState var isPrivateRoomSelected: Bool = false
        let isHost: Bool = true
        @PresentationState var maxPeopleCountSheet: MaxPeopleCountFeature.State?
        @PresentationState var gameCategorySelectSheet: GameCategorySelectFeature.State?
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
                return .none
            case .privateRoomToggleButtonTapped:
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
            }
        }
        .ifLet(\.$maxPeopleCountSheet, action: \.maxPeopleCountSheet) {
            MaxPeopleCountFeature()
        }
        .ifLet(\.$gameCategorySelectSheet, action: \.gameCategorySelectSheet) {
            GameCategorySelectFeature()
        }
    }
}
