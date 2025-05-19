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
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
        case maxNumOfPeopleButtonTapped
        case gameCategorySettingButtonTapped
        case privateRoomCodeButtonTapped
        case privateRoomToggleButtonTapped
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
                return .none
            case .gameCategorySettingButtonTapped:
                return .none
            case .privateRoomCodeButtonTapped:
                return .none
            case .privateRoomToggleButtonTapped:
                return .none
            }
        }
    }
}
