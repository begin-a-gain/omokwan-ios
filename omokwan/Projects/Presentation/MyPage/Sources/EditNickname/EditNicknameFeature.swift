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
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        enum NicknameValidStatus {
            case duplicated
            case invalidFormat
            case empty
            case valid
        }
        
        @Shared(.userInfo) var userInfo = UserInfo()
        @BindingState var nickname: String = ""
        var nicknameValidStatus: NicknameValidStatus?
        var isButtonEnabled: Bool = false
    }

    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.nickname = state.userInfo.nickname
                return .none
            case .navigateToBack:
                return .none
            case .binding:
                return .none
            }
        }
    }
}
