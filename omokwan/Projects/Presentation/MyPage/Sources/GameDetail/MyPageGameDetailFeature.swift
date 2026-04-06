//
//  MyPageGameDetailFeature.swift
//  MyPage
//
//  Created by 김동준 on 1/14/26
//

import ComposableArchitecture
import Domain
import Base
import Util
import Foundation

@Reducer
public struct MyPageGameDetailFeature {
    public init() {}
    
    public struct State: Equatable {
        public init(
            type: MyPageGameDetailType,
            info: [MyPageGameDetailModel]
        ) {
            self.type = type
            self.models = info
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        
        var isLoading: Bool = false
        let type: MyPageGameDetailType
        var models: [MyPageGameDetailModel]
    }

    public enum Action {
        case onAppear
        case navigateToBack
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case buttonTapped(MyPageGameDetailModel)
        case navigateToGameDetail(Int, String, String)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .navigateToBack:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .buttonTapped(let roomInfo):
                let selectedDateString = Date.now.formattedString(
                    format: DateFormatConstants.yearMonthDayRequestFormat
                )

                return .send(.navigateToGameDetail(roomInfo.gameID, roomInfo.title, selectedDateString))
            case .navigateToGameDetail:
                return .none
            }
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
    }
}
