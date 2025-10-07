//
//  StickyCalendarFeature.swift
//  GameDetail
//
//  Created by 김동준 on 10/5/25
//

import ComposableArchitecture
import Domain
import Foundation
import Util

@Reducer
public struct StickyCalendarFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init(gameID: Int, selectedDateString: String) {
            self.gameID = gameID
            let now = Date()
            self.now = now
            let weekday = Calendar.current.component(.weekday, from: now)
            let days = ["일", "월", "화", "수", "목", "금", "토"]
            self.todayString = days[weekday - 1]
            self.selectedDateString = selectedDateString
            let nowDateString = now.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
            self.todayYearMonth = String(nowDateString.prefix(7))
            self.todayOnlyDay = String(nowDateString.suffix(2))
        }
        
        let gameID: Int
        var dateUserStatusInfos: [String: [GameDetailDate]] = [:]
        var savedPreviousDateUserStatusInfos: [String: [GameDetailDate]] = [:]
        var isTopProgressVisible: Bool = false

        var pagingCursor: PagingCursor = .today
        
        let todayString: String
        let selectedDateString: String
        var now: Date
        
        var previousDateCursor: String = ""
        var nextDateCursor: String = ""
        var needPreviousDatePaging: Bool = false
        var needNextDatePaging: Bool = false
        let todayYearMonth: String
        let todayOnlyDay: String
        
        var savedContentOffset: CGFloat = 0
        var savedContentHeight: CGFloat = 0
        
        var isLoadingTop: Bool = false
        var isLoadingBottom: Bool = false
        var isUpdatingSnapshot: Bool = false
        var isInitialLoad: Bool = true
    }
    
    public enum Action {
        case onAppear
        case fetchInfoWithPaging(PagingCursor)
        case showAlert(NetworkError)
        case gameDetailInfoFetched(MyGameDetailInfo, PagingCursor)
        case setTopProgressVisible(Bool)
        case setSavedContentOffset(CGFloat)
        case setSavedContentHeight(CGFloat)
        case scrollBottomReached
        case scrollTopReached(CGFloat, CGFloat)
        case nextPagingDataUpdated
        case previousPagingDataUpdated
        case setIsUpdatingSnapshot(Bool)
        case setPreviousDateUserStatusInfosForSaving([String: [GameDetailDate]])
        case setIsInitialLoad(Bool)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .fetchInfoWithPaging(let pagingCursor):
                state.pagingCursor = pagingCursor
                
                let dateString = switch pagingCursor {
                case .today: state.selectedDateString
                case .previous: state.previousDateCursor
                case .next: state.nextDateCursor
                }

                let request = MyGameDetailPagingRequest(
                    gameID: state.gameID,
                    pageSize: pagingCursor == .today ? 6 : 10,
                    date: dateString
                )
                
                return .run { send in
                    await send(
                        fetchDetailInfoWithPaging(
                            request: request,
                            pagingCursor: pagingCursor
                        )
                    )
                }
            case let .gameDetailInfoFetched(info, pagingCursor):
                setPagingInfo(&state, info, pagingCursor)
                setDateUserStatusInfos(&state, info.dates)
                return .none
            case .showAlert:
                return .none
            case .setTopProgressVisible(let value):
                state.isTopProgressVisible = value
                return .none
            case .setSavedContentOffset(let value):
                state.savedContentOffset = value
                return .none
            case .setSavedContentHeight(let value):
                state.savedContentHeight = value
                return .none
            case let .scrollTopReached(currentScrollOffsetY, currentContentHeight):
                state.isLoadingTop = true
                state.isTopProgressVisible = true
                state.savedContentOffset = currentScrollOffsetY
                state.savedContentHeight = currentContentHeight
                return .send(.fetchInfoWithPaging(.next))
            case .scrollBottomReached:
                state.isLoadingBottom = true
                return .send(.fetchInfoWithPaging(.previous))
            case .nextPagingDataUpdated:
                state.isLoadingTop = false
                state.isUpdatingSnapshot = false
                state.isTopProgressVisible = false
                return .none
            case .previousPagingDataUpdated:
                state.isLoadingBottom = false
                state.isUpdatingSnapshot = false
                return .none
            case .setIsUpdatingSnapshot(let value):
                state.isUpdatingSnapshot = value
                return .none
            case .setPreviousDateUserStatusInfosForSaving(let value):
                state.savedPreviousDateUserStatusInfos = value
                return .none
            case .setIsInitialLoad(let value):
                state.isInitialLoad = value
                return .none
            }
        }
    }
}

private extension StickyCalendarFeature {
    func fetchDetailInfoWithPaging(
        request: MyGameDetailPagingRequest,
        pagingCursor: PagingCursor
    ) async -> Action {
        let response = await gameUseCase.fetchDetailInfoWithPaging(
            request.gameID,
            request.date,
            request.pageSize
        )
        
        switch response {
        case .success(let myGameDetailInfo):
            return .gameDetailInfoFetched(myGameDetailInfo, pagingCursor)
        case .failure(let error):
            return .showAlert(error)
        }
    }
    
    func setPagingInfo(
        _ state: inout State,
        _ info: MyGameDetailInfo,
        _ pagingCursor: PagingCursor
    ) {
        switch pagingCursor {
        case .today:
            state.needPreviousDatePaging = info.needPreviousDatePaging
            state.needNextDatePaging = info.needNextDatePaging
            state.previousDateCursor = info.previousDateCursor
            state.nextDateCursor = info.nextDateCursor
        case .previous:
            state.needPreviousDatePaging = info.needPreviousDatePaging
            state.previousDateCursor = info.previousDateCursor
        case .next:
            state.needNextDatePaging = info.needNextDatePaging
            state.nextDateCursor = info.nextDateCursor
        }
    }
    
    func setDateUserStatusInfos(_ state: inout State, _ dates: [GameDetailDate]) {
        let newDateUserStatusInfos = initializeDateUserStatusInfos(from: dates)
        
        for (yearMonth, newDates) in newDateUserStatusInfos {
            if state.dateUserStatusInfos[yearMonth] == nil {
                state.dateUserStatusInfos[yearMonth] = newDates
            } else {
                let combinedDates = (state.dateUserStatusInfos[yearMonth] ?? []) + newDates
                
                var uniqueDates: [String: GameDetailDate] = [:]
                for date in combinedDates {
                    uniqueDates[date.date] = date
                }
                
                state.dateUserStatusInfos[yearMonth] = Array(uniqueDates.values).sorted { $0.date > $1.date }
            }
        }
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
}
