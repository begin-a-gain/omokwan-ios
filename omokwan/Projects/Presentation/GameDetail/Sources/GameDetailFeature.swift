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
        var now: Date = Date()
        
        // About Date
        var previousScrollCount: Int = 1
        var nextMonthScrollCount: Int = 1
        
        var calendarStartDate: Date {
            now.seoulNow.dateForFirstDayOfMonth(nMonthsAgo: previousScrollCount)
        }
         
        var calendarEndDate: Date {
            now.seoulNow.dateForLastDayOfMonth(nMonthsAfter: nextMonthScrollCount)
        }
        
        var dateTimeRange: [Date] {
            Date.getRangeOfDates(from: calendarStartDate, to: calendarEndDate)
        }
        
        var dateDictionary: [String: [Date]] {
            Dictionary(grouping: dateTimeRange) { date in
                date.formattedString(format: DateFormatConstants.scrollHeaderFormat)
            }
        }
        
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
        case avatarButtonTapped(Int)
        case detailUserInfoFetched(DetailUserInfo)
        
        case userAvatarInfoSheet(PresentationAction<UserAvatarInfoFeature.Action>)
        case shootStoneSuccess(String)
        case shootStoneFailed
        case kickOutAlertButtonTapped(String)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let request = MyGameDetailPagingRequest(
                    gameID: state.gameID,
                    pageSize: 10,
                    date: state.now
                        .formattedString(format: DateFormatConstants.yearMonthDayRequestFormat),
                    previousDate: "",
                    nextDate: "",
                    needNextPaging: false
                )
                return .send(.fetchInfoWithPaging(request))
            case .fetchInfoWithPaging(let request):
                state.isLoading = true
                return .run { send in
                    await send(fetchDetailInfoWithPaging(request: request))
                }
            case .gameDetailInfoFetched(let info):
                state.isLoading = false
                
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
        var dateString: String {
            if request.nextDate.isEmpty || request.previousDate.isEmpty {
                return request.date
            } else {
                return request.needNextPaging
                ? request.nextDate
                : request.previousDate
            }
        }
        
        let response = await gameUseCase.fetchDetailInfoWithPaging(
            request.gameID,
            dateString,
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
}
