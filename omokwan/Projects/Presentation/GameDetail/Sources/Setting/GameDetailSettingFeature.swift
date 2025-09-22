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
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        
        @BindingState var gameName: String = ""
        var maxNumOfPeople: Int = 5
        var selectedCategory: GameCategory?
        var categories: [GameCategory] = []
        
        var privateRoomPassword: String?
        var isPrivateRoom: Bool = false
        let isHost: Bool = true
        
        @PresentationState var maxNumOfPeopleSheet: CommonMaxNumOfPeopleFeature.State?
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
            case .navigateToBack:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .binding:
                return .none
            case .maxNumOfPeopleButtonTapped:
                state.maxNumOfPeopleSheet = .init(selectedMaxNumOfPeopleCount: state.maxNumOfPeople)
                return .none
            case .gameCategorySettingButtonTapped:
                return .none
            case .privateRoomCodeButtonTapped:
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
                return .none
            case .inviteButtonTapped:
                return .none
            case .hostChangeButtonTapped:
                return .none
            case .exitButtonTapped:
                return .none
            case .categoriesFetched(let categories):
                state.isLoading = false
                state.categories = categories
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
            }
        }
        .ifLet(\.$maxNumOfPeopleSheet, action: \.maxNumOfPeopleSheet) {
            CommonMaxNumOfPeopleFeature()
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
