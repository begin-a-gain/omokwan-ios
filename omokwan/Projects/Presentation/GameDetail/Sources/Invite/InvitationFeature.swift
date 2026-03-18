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
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .inviteButtonTapped:
                return .none
            case .fetchUserList(let cursor):
                if cursor == nil {
                    state.isShimmerLoading = true
                    state.nextCursor = nil
                    state.hasNext = false
                }
                
                return .run { [nickname = state.nickname] send in
                    await send(fetchUsers(nickname, cursor))
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
    func fetchUsers(_ nickname: String, _ cursor: String?) async -> Action {
        let pagingSize = 20
        let response = await gameUseCase.fetchUsers(
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
}
