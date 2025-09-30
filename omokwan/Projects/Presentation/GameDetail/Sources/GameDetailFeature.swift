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
        public init(gameID: Int, gameTitle: String) {
            self.gameID = gameID
            self.gameTitle = gameTitle
            self.now = Date()
            let weekday = Calendar.current.component(.weekday, from: now)
            let days = ["일", "월", "화", "수", "목", "금", "토"]
            self.todayString = days[weekday - 1]
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case kickOut(String)
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        
        let gameID: Int
        let gameTitle: String
        var now: Date
        let todayString: String
        var gameUserInfos: [GameUserInfo?] = []
        
        var dateUserStatusInfos: [String: [GameDetailDate]] = [:]
        var isBottomButtonEnable: Bool = true
        
        @PresentationState var userAvatarInfoSheet: UserAvatarInfoFeature.State?
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case menuButtonTapped
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        
        case fetchInfoWithPaging(MyGameDetailPagingRequest)
        case gameDetailInfoFetched(MyGameDetailInfo)
        case avatarButtonTapped(Int?)
        case detailUserInfoFetched(DetailUserInfo)
        
        case userAvatarInfoSheet(PresentationAction<UserAvatarInfoFeature.Action>)
        case shootStoneSuccess(String)
        case shootStoneFailed
        case kickOutAlertButtonTapped(String)
        case updateTodayOmokStatus
        case omokStatusUpdated(OmokStoneStatus)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let request = MyGameDetailPagingRequest(
                    gameID: state.gameID,
                    pageSize: 10,
                    date: state.now
                        .formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
                )
                return .send(.fetchInfoWithPaging(request))
            case .fetchInfoWithPaging(let request):
                state.isLoading = true
                return .run { send in
                    await send(fetchDetailInfoWithPaging(request: request))
                }
            case .gameDetailInfoFetched(let info):
                state.isLoading = false
                
                setDateUserStatusInfos(&state, info.dates)
                setGameUserInfo(&state, info.users)
                return .none
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
            case .detailUserInfoFetched(let detailUserInfo):
                state.isLoading = false
                let roles: [ParticipantRole] = [.me, .host, .other]
                let index = Int.random(in: 0..<roles.count)
                let role = roles[index]

                // TODO: 방장 확인한 뒤, role 정확히 보내기
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
                state.isBottomButtonEnable = status == .inCompleted
                // TODO: 오늘의 오목돌 바꾸기
                return .none
            }
        }
        .ifLet(\.$userAvatarInfoSheet, action: \.userAvatarInfoSheet) {
            UserAvatarInfoFeature()
        }

        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
    }
}

private extension GameDetailFeature {
    func fetchDetailInfoWithPaging(request: MyGameDetailPagingRequest) async -> Action {
        let response = await gameUseCase.fetchDetailInfoWithPaging(
            request.gameID,
            request.date,
            request.pageSize
        )
        
        switch response {
        case .success(let myGameDetailInfo):
            return .gameDetailInfoFetched(myGameDetailInfo)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func fetchDetailUserInfo(gameID: Int, userID: Int) async -> Action {
        let response = await gameUseCase.fetchDetailUserInfo(gameID, userID)
        
        switch response {
        case .success(let detailUserInfo):
            return .detailUserInfoFetched(detailUserInfo)
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
    
    func initializeDateUserStatusInfos(from dates: [GameDetailDate]) -> [String: [GameDetailDate]] {
        var dateUserStatusInfos: [String: [GameDetailDate]] = [:]
        
        for gameDetailDate in dates {
            let yearMonth = String(gameDetailDate.date.prefix(7))
            let dayOnly = String(gameDetailDate.date.suffix(2))
            
            var updatedGameDetailDate = gameDetailDate
            updatedGameDetailDate.date = dayOnly
            
            if updatedGameDetailDate.userStatus.count <= 5 {
                let neededCount = 5 - updatedGameDetailDate.userStatus.count
                updatedGameDetailDate.userStatus.append(contentsOf: Array(repeating: nil, count: neededCount))
            }
            
            if dateUserStatusInfos[yearMonth] == nil {
                dateUserStatusInfos[yearMonth] = []
            }
            
            dateUserStatusInfos[yearMonth]?.append(updatedGameDetailDate)
        }
        
        for yearMonth in dateUserStatusInfos.keys {
            dateUserStatusInfos[yearMonth]?.sort { $0.date > $1.date }
        }
        
        return dateUserStatusInfos
    }
    
    func setDateUserStatusInfos(_ state: inout State, _ dates: [GameDetailDate]) {
        let newDateUserStatusInfos = initializeDateUserStatusInfos(from: dates)
        
        // TODO: 아래 페이징 추가 로직은 이후 수정 예정
        for (yearMonth, newDates) in newDateUserStatusInfos {
            if state.dateUserStatusInfos[yearMonth] == nil {
                state.dateUserStatusInfos[yearMonth] = newDates
            } else {
                var combinedDates = (state.dateUserStatusInfos[yearMonth] ?? []) + newDates
                
                var uniqueDates: [String: GameDetailDate] = [:]
                for date in combinedDates {
                    uniqueDates[date.date] = date
                }
                
                state.dateUserStatusInfos[yearMonth] = Array(uniqueDates.values).sorted { $0.date < $1.date }
            }
        }
    }
}
