//
//  InvitationFeature.swift
//  GameDetail
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct InvitationFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        
        public init(
            gameID: Int,
            gameUserInfos: [GameUserInfo],
            maxParticipants: Int
        ) {
            self.gameID = gameID
            self.currentUserCount = gameUserInfos.count
            self.maxParticipants = maxParticipants
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        var isShimmerLoading: Bool = false

        let gameID: Int
        let currentUserCount: Int
        let maxParticipants: Int
        
        var selectedUserInfoList: [GameUserInfo] = []
        var allUserInfoList: [GameUserInfo] = [
            .init(userID: 1, nickname: "가나다라"),
            .init(userID: 2, nickname: "가나"),
            .init(userID: 3, nickname: "가나라"),
            .init(userID: 4, nickname: "가나다"),
            .init(userID: 5, nickname: "가나다마바라")
        ]
        
        var searchText: String = ""
        var isBottomButtonEnable: Bool {
            !selectedUserInfoList.isEmpty
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case inviteButtonTapped
        case userInfoRowCardTapped(GameUserInfo)
        case sendToast(String)
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
            case .binding:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .inviteButtonTapped:
                return .none
            case .userInfoRowCardTapped(let userInfo):
                if let index = state.selectedUserInfoList.firstIndex(of: userInfo) {
                    state.selectedUserInfoList.remove(at: index)
                    return .none
                }
                
                let currentUserCount = state.currentUserCount + state.selectedUserInfoList.count
                guard currentUserCount < state.maxParticipants else {
                    return .send(.sendToast("초대 가능 인원을 초과했어요."))
                }
                
                state.selectedUserInfoList.append(userInfo)
                return .none
            case .sendToast:
                return .none
            }
        }
    }
}
