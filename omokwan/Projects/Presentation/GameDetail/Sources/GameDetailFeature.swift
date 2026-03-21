//
//  GameDetailFeature.swift
//  GameDetail
//
//  Created by 김동준 on 5/12/25
//

import ComposableArchitecture
import Domain
import Foundation
import Util
import Base

@Reducer
public struct GameDetailFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init(
            gameID: Int,
            gameTitle: String,
            selectedDateString: String
        ) {
            self.gameID = gameID
            self.gameTitle = gameTitle
            self.stickyCalendarState = .init(
                gameID: gameID,
                selectedDateString: selectedDateString
            )
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case kickOut(String, Int)
        }
        
        enum BottomButtonType {
            case possible
            case alreadyDone
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        
        let gameID: Int
        let gameTitle: String
        var gameUserInfos: [GameUserInfo?] = []
        var stickyCalendarState: StickyCalendarFeature.State
        var bottomButtonType: BottomButtonType {
            stickyCalendarState.isTodayStoneCompleted
                ? .alreadyDone
                : .possible
        }
        
        @PresentationState var userAvatarInfoSheet: UserAvatarInfoFeature.State?
        @Shared(.userInfo) var userInfo = UserInfo()
        var isComboSheetPresented: Bool = false
        var comboCount: Int = 0
        var maxParticipants: Int = 5
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case menuButtonTapped
        case navigateToSetting(Int, [GameUserInfo])
        case navigateToInvitation(Int, [GameUserInfo], Int)
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        
        case avatarButtonTapped(Int?)
        case detailUserInfoFetched(DetailUserInfo, Int)
        case userKicked(String, Int)
        
        case userAvatarInfoSheet(PresentationAction<UserAvatarInfoFeature.Action>)
        case shootStoneSuccess(String)
        case shootStoneFailed
        case kickOutAlertButtonTapped(String, Int)
        case updateTodayOmokStatus
        case omokStatusUpdated(OmokStoneStatus)
        
        case stickyCalendarAction(StickyCalendarFeature.Action)
        case setComboSheet(Bool)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                
                return .send(.stickyCalendarAction(.fetchInfoWithPaging(.today)))
            case .navigateToBack:
                return .none
            case .menuButtonTapped:
                let gameID = state.gameID
                let gameUserInfos = state.gameUserInfos.compactMap { $0 }
                return .send(.navigateToSetting(gameID, gameUserInfos))
            case .navigateToSetting:
                return .none
            case .navigateToInvitation:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .avatarButtonTapped(let userID):
                guard let userID else {
                    return .send(
                        .navigateToInvitation(
                            state.gameID,
                            state.gameUserInfos.compactMap { $0 },
                            state.maxParticipants
                        )
                    )
                }
                
                state.isLoading = true
                
                let gameID = state.gameID
                return .run { send in
                    await send(fetchDetailUserInfo(gameID: gameID, userID: userID))
                }
            case let .detailUserInfoFetched(detailUserInfo, userID):
                state.isLoading = false
                let myID = state.userInfo.id
                guard let myInfo = state.gameUserInfos.first(where: { $0?.userID == myID }) ?? nil else { return .none }

                let equalsID = myID == userID
                var role: ParticipantRole {
                    if equalsID { return .me }
                    if myInfo.isHost { return .host }
                    return .other
                }
                
                state.userAvatarInfoSheet = .init(
                    detailUserInfo: detailUserInfo,
                    participantRole: role,
                    userID: userID
                )

                return .none
            case .userAvatarInfoSheet(.presented(let sheetAction)):
                switch sheetAction {
                case .shootStoneButtonTapped(let nickname):
                    let randomValue = Int.random(in: 0..<2)
                    if randomValue == 0 {
                        state.userAvatarInfoSheet = nil
                        return .send(.shootStoneSuccess(nickname))
                    } else {
                        // TODO: 실패 어떻게 처리할지 논의 필요
                        state.userAvatarInfoSheet = nil
                        return .send(.shootStoneFailed)
                    }
                case let .kickOutButtonTapped(nickname, userID):
                    state.userAvatarInfoSheet = nil
                    
                    return .send(.showAlert(.kickOut(nickname, userID)))
                default:
                    return .none
                }
            case .userAvatarInfoSheet(.dismiss):
                return .none
            case .shootStoneSuccess:
                return .none
            case .shootStoneFailed:
                return .none
            case let .kickOutAlertButtonTapped(nickname, userID):
                let gameID = state.gameID
                state.isLoading = true
                return .merge([
                    .send(.alertAction(.dismiss)),
                    .run { send in
                        await send(kickOutUser(gameID, userID, nickname))
                    },
                ])
            case .updateTodayOmokStatus:
                state.isLoading = true
                let gameID = state.gameID
                return .run { send in
                    await send(updateTodayOmokStatus(gameID))
                }
            case .omokStatusUpdated(let status):
                state.isLoading = false
                // TODO: 이거 stauts가 실패한 케이스로 왔을 떈 어떻게 처리할지 논의.
                return .send(.stickyCalendarAction(.checkTodayOmokStatus(status)))
            case .stickyCalendarAction(let stickyAction):
                switch stickyAction {
                case let .gameDetailInfoFetched(info, _):
                    state.isLoading = false
                    state.maxParticipants = info.matchInfo.maxParticipants
                    setGameUserInfo(&state, info.users)
                    return .none
                case let .comboAchieved(comboCount):
                    state.comboCount = comboCount
                    state.isComboSheetPresented = true
                    return .none
                case .showAlert(let error):
                    return .send(.showAlert(.error(error)))
                case .needRefresh:
                    return .send(.onAppear)
                default:
                    return .none
                }
            case let .userKicked(_, userID):
                state.isLoading = false
                let filteredUserList = state.gameUserInfos
                    .compactMap { $0 }
                    .filter { $0.userID != userID }
                    
                setGameUserInfo(&state, filteredUserList)
                return .send(.stickyCalendarAction(.needRefresh))
            case .setComboSheet(let value):
                state.isComboSheetPresented = value
                return .none
            }
        }
        .ifLet(\.$userAvatarInfoSheet, action: \.userAvatarInfoSheet) {
            UserAvatarInfoFeature()
        }

        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
        
        Scope(state: \.stickyCalendarState, action: \.stickyCalendarAction) {
            StickyCalendarFeature()
        }
    }
}

private extension GameDetailFeature {
    func fetchDetailUserInfo(gameID: Int, userID: Int) async -> Action {
        let response = await gameUseCase.fetchDetailUserInfo(gameID, userID)
        
        switch response {
        case .success(let detailUserInfo):
            return .detailUserInfoFetched(detailUserInfo, userID)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func updateTodayOmokStatus(_ gameID: Int) async -> Action {
        let response = await gameUseCase.updateTodayGameStatus(gameID)
        
        switch response {
        case .success(let status):
            return .omokStatusUpdated(status)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func kickOutUser(
        _ gameID: Int,
        _ userID: Int,
        _ nickname: String
    ) async -> Action {
        let response = await gameUseCase.kickOutUser(gameID, userID)
        
        switch response {
        case .success:
            return .userKicked(nickname, userID)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}

private extension GameDetailFeature {
    func setGameUserInfo(_ state: inout State, _ infos: [GameUserInfo]) {
        if infos.compactMap({ $0 }).count == state.gameUserInfos.count {
            return
        }
        
        var newInfos: [GameUserInfo?] = infos.map { $0 }
        
        if newInfos.count < 5, newInfos.count != state.maxParticipants {
            newInfos.append(nil)
        }
        
        state.gameUserInfos = newInfos
    }
}
