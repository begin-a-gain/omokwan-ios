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
            case kickOut(String)
        }
        
        enum BottomButtonType {
            case impossible
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
            if stickyCalendarState.hasTodayDateInCalendar {
                stickyCalendarState.isTodayStoneCompleted
                    ? .alreadyDone
                    : .possible
            } else {
                .impossible
            }
        }
        
        @PresentationState var userAvatarInfoSheet: UserAvatarInfoFeature.State?
        @Shared(.userInfo) var userInfo = UserInfo()
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case menuButtonTapped
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        
        case avatarButtonTapped(Int?)
        case detailUserInfoFetched(DetailUserInfo, Int)
        
        case userAvatarInfoSheet(PresentationAction<UserAvatarInfoFeature.Action>)
        case shootStoneSuccess(String)
        case shootStoneFailed
        case kickOutAlertButtonTapped(String)
        case updateTodayOmokStatus
        case omokStatusUpdated(OmokStoneStatus)
        
        case stickyCalendarAction(StickyCalendarFeature.Action)
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
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .avatarButtonTapped(let userID):
                guard let userID else {
                    // TODO: 초대 유도
                    return .none
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
                
                state.userAvatarInfoSheet = .init(detailUserInfo: detailUserInfo, participantRole: role)

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
                case .kickOutButtonTapped(let nickname):
                    state.userAvatarInfoSheet = nil
                    
                    return .send(.showAlert(.kickOut(nickname)))
                default:
                    return .none
                }
            case .userAvatarInfoSheet(.dismiss):
                return .none
            case .shootStoneSuccess:
                return .none
            case .shootStoneFailed:
                return .none
            case .kickOutAlertButtonTapped:
                return .send(.alertAction(.dismiss))
            case .updateTodayOmokStatus:
                state.isLoading = true
                let gameID = state.gameID
                return .run { send in
                    await send(updateTodayOmokStatus(gameID))
                }
            case .omokStatusUpdated(let status):
                state.isLoading = false
                return .send(.stickyCalendarAction(.checkTodayOmokStatus(status)))
            case .stickyCalendarAction(let stickyAction):
                switch stickyAction {
                case let .gameDetailInfoFetched(info, _):
                    state.isLoading = false
                    setGameUserInfo(&state, info.users)
                    return .none
                case .showAlert(let error):
                    return .send(.showAlert(.error(error)))
                default:
                    return .none
                }
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
}

private extension GameDetailFeature {
    func setGameUserInfo(_ state: inout State, _ infos: [GameUserInfo]) {
        if infos.compactMap({ $0 }).count == state.gameUserInfos.count {
            return
        }
        
        var newInfos: [GameUserInfo?] = infos.map { $0 }
        
        if newInfos.count < 5 {
            newInfos.append(nil)
        }
        
        state.gameUserInfos = newInfos
    }
}
