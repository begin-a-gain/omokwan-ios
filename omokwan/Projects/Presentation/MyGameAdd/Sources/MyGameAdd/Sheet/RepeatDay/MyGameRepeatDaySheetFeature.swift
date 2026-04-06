//
//  MyGameRepeatDaySheetFeature.swift
//  MyGameAdd
//
//  Created by 김동준 on 12/7/24
//

import ComposableArchitecture
import Domain

public struct MyGameRepeatDaySheetFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        public init(selectedRepeatDayValue: MyGameAddRepeatDayType) {
            selectedRepeatDay = selectedRepeatDayValue
        }
        @BindingState var selectedRepeatDay: MyGameAddRepeatDayType
        let repeatDayAllCases: [MyGameAddRepeatDayType] = MyGameAddRepeatDayType.allCases
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectButtonTapped(MyGameAddRepeatDayType)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .selectButtonTapped:
                return .none
            }
        }
    }
}
