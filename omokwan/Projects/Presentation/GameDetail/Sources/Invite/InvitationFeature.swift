//
//  InvitationFeature.swift
//  GameDetail
//
//  Created by jumy on 3/14/26.
//

import ComposableArchitecture
import Domain
import Base
import Foundation

@Reducer
public struct InvitationFeature {
    @Dependency(\.gameUseCase) private var gameUseCase
    @Dependency(\.mainQueue) private var mainQueue
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        enum SearchDebounceID { case nickname }
        
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
        var allUserInfoList: [GameUserInfo] = []
        var nextCursor: String?
        var hasNext: Bool = false
        
        var nickname: String = ""
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
        case inviteCompleted(String)
        case fetchUserList(cursor: String?)
        case userListFetched(GameUserPagingInfo, isFirstPage: Bool)
        case userInfoRowCardTapped(GameUserInfo)
        case sendToast(String)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.nickname) { oldValue, newValue in
                Reduce { state, action in
                    if oldValue.isEmpty, newValue.isEmpty {
                        return .none
                    }
                    
                    return .send(.fetchUserList(cursor: nil))
                        .debounce(
                            id: State.SearchDebounceID.nickname,
                            for: .milliseconds(400),
                            scheduler: mainQueue
                        )
                }
            }
        
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchUserList(cursor: nil))
            case .navigateToBack:
                return .none
            case .binding:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.isShimmerLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .inviteButtonTapped:
                state.isLoading = true
                let gameID = state.gameID
                let userIDs = state.selectedUserInfoList.map(\.userID)
                let message = makeInviteSuccessMessage(state.selectedUserInfoList)
                return .run { send in
                    await send(inviteUsers(gameID: gameID, userIDs: userIDs, successMessage: message))
                }
            case .inviteCompleted(let message):
                state.isLoading = false
                return .concatenate([
                    .send(.sendToast(message)),
                    .send(.navigateToBack)
                ])
            case .fetchUserList(let cursor):
                if cursor == nil {
                    state.isShimmerLoading = true
                    state.nextCursor = nil
                    state.hasNext = false
                }
                
                return .run { [gameID = state.gameID, nickname = state.nickname] send in
                    await send(fetchUsers(gameID, nickname, cursor))
                }
            case let .userListFetched(info, isFirstPage):
                state.isShimmerLoading = false
                state.nextCursor = info.nextCursor.isEmpty ? nil : info.nextCursor
                state.hasNext = info.hasNext
                
                if isFirstPage {
                    state.allUserInfoList = info.users
                } else {
                    state.allUserInfoList.append(contentsOf: info.users)
                }
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

private extension InvitationFeature {
    func fetchUsers(_ gameID: Int, _ nickname: String, _ cursor: String?) async -> Action {
        let pagingSize = 20
        let response = await gameUseCase.fetchUsers(
            gameID,
            nickname.isEmpty ? nil : nickname,
            cursor,
            pagingSize
        )
        
        switch response {
        case .success(let info):
            return .userListFetched(info, isFirstPage: cursor == nil)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func inviteUsers(
        gameID: Int,
        userIDs: [Int],
        successMessage: String
    ) async -> Action {
        let response = await gameUseCase.inviteUsers(gameID, userIDs)
        
        switch response {
        case .success:
            return .inviteCompleted(successMessage)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func makeInviteSuccessMessage(_ selectedUserInfoList: [GameUserInfo]) -> String {
        if selectedUserInfoList.count == 1,
           let nickname = selectedUserInfoList.first?.nickname {
            return "‘\(nickname)’님을 대국에 초대했어요."
        }
        
        return "\(selectedUserInfoList.count)명을 대국에 초대했어요."
    }
}
