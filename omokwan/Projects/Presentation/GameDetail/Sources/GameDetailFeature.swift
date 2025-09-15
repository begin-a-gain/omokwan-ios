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
                // TODO: id -> 상세 sheet 띄우기

                print(detailUserInfo)
                return .none
            }
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
