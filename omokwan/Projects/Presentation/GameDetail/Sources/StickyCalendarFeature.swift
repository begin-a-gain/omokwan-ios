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
            self.nowDateString = nowDateString
            self.todayYearMonth = String(nowDateString.prefix(7))
            self.todayOnlyDay = String(nowDateString.suffix(2))
        }
        
        let gameID: Int
        var dateUserStatusInfos: [String: [GameDetailDate]] = [:]
        var savedPreviousDateUserStatusInfos: [String: [GameDetailDate]] = [:]
        var isTopProgressVisible: Bool = false

        var pagingCursor: PagingCursor = .today
        
        let todayString: String
        var selectedDateString: String
        var now: Date
        let nowDateString: String
        
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
        
        var sortedKeys: [Dictionary<String, [GameDetailDate]>.Keys.Element] {
            dateUserStatusInfos.keys.sorted(by: >)
        }
        
        var isTodayStoneCompleted: Bool = true
        var shouldReloadToday: Bool = false
        var comboUpdatedDates: [String] = []
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
        case checkTodayOmokStatus(OmokStoneStatus)
        case resetReloadFlag
        case clearComboUpdatedDates
        case needRefresh
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
            case .checkTodayOmokStatus(let status):
                state.isTodayStoneCompleted = status == .completed
                
                let flatMap = state.dateUserStatusInfos.flatMap { $0.value }
                    .sorted{ $0.originalDate > $1.originalDate }
                let todayDateString = state.todayYearMonth+"-"+state.todayOnlyDay
                
                guard let todayMatchedIndex = flatMap.firstIndex(where: { $0.originalDate == todayDateString }) else {
                    return .send(.needRefresh)
                }
                
                guard let currentMonthGameDetailDates = state.dateUserStatusInfos[String(flatMap[todayMatchedIndex].originalDate.prefix(7))],
                      let todaySameDateIndex = currentMonthGameDetailDates.firstIndex(where: { $0.date == String(flatMap[todayMatchedIndex].originalDate.suffix(2)) }) else {
                    return .none
                }
                
                if todayMatchedIndex + 1 < flatMap.count {
                    markOmokStatusWithPreviousData(
                        state: &state,
                        todayGameDetailDate: currentMonthGameDetailDates[todaySameDateIndex],
                        currentMonthGameDetailDates: currentMonthGameDetailDates,
                        todaySameDateIndex: todaySameDateIndex,
                        todayMatchedIndex: todayMatchedIndex,
                        allGameDetailDates: flatMap
                    )
                    return .none
                } else {
                    markOmokStatusWithoutPreviousData(
                        state: &state,
                        todayGameDetailDate: currentMonthGameDetailDates[todaySameDateIndex],
                        currentMonthGameDetailDates: currentMonthGameDetailDates,
                        todaySameDateIndex: todaySameDateIndex
                    )
                    return .none
                }
            case .resetReloadFlag:
                state.shouldReloadToday = false
                return .none
            case .clearComboUpdatedDates:
                state.comboUpdatedDates = []
                return .none
            case .needRefresh:
                state.isInitialLoad = true
                state.selectedDateString = Date.now.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
                state.dateUserStatusInfos = [:]
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
        
        state.isTodayStoneCompleted = info.isTodayCompleted
    }
    
    func setDateUserStatusInfos(_ state: inout State, _ dates: [GameDetailDate]) {
        let newDateUserStatusInfos = initializeDateUserStatusInfos(state: &state, from: dates)
        
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

    func initializeDateUserStatusInfos(
        state: inout State,
        from dates: [GameDetailDate]
    ) -> [String: [GameDetailDate]] {
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
    
    func markOmokStatusWithoutPreviousData(
        state: inout State,
        todayGameDetailDate: GameDetailDate,
        currentMonthGameDetailDates: [GameDetailDate],
        todaySameDateIndex: Int
    ) {
        var todayGameDetailDate = todayGameDetailDate
        var currentMonthGameDetailDates = currentMonthGameDetailDates
        
        if let myUserStatus = todayGameDetailDate.userStatus[0] {
            todayGameDetailDate.userStatus[0] = GameDetailUserStatus(
                userID: myUserStatus.userID,
                isCompleted: true,
                streakCount: myUserStatus.streakCount,
                isCombo: false
            )
        }
        
        currentMonthGameDetailDates[todaySameDateIndex] = todayGameDetailDate
        state.dateUserStatusInfos[state.todayYearMonth] = currentMonthGameDetailDates
        
        state.shouldReloadToday = true
    }
    
    func markOmokStatusWithPreviousData(
        state: inout State,
        todayGameDetailDate: GameDetailDate,
        currentMonthGameDetailDates: [GameDetailDate],
        todaySameDateIndex: Int,
        todayMatchedIndex: Int,
        allGameDetailDates: [GameDetailDate]
    ) {
        let previousGameDetailDate = allGameDetailDates[todayMatchedIndex + 1]
        var currentMonthGameDetailDates = currentMonthGameDetailDates
        var todayDate = currentMonthGameDetailDates[todaySameDateIndex]
        
        if let myUserStatus = todayDate.userStatus[0] {
            let isCombo = previousGameDetailDate.userStatus[0]?.isCombo ?? false
            if isCombo {
                todayDate.userStatus[0] = GameDetailUserStatus(
                    userID: myUserStatus.userID,
                    isCompleted: true,
                    streakCount: myUserStatus.streakCount,
                    isCombo: true
                )
                
                currentMonthGameDetailDates[todaySameDateIndex] = todayDate
                state.dateUserStatusInfos[state.todayYearMonth] = currentMonthGameDetailDates
            } else {
                let streakCount = previousGameDetailDate.userStatus[0]?.streakCount ?? 0
                if streakCount >= 4 {
                    let comboRange = todayMatchedIndex...min(todayMatchedIndex + 4, allGameDetailDates.count - 1)
                    state.comboUpdatedDates = comboRange.map { allGameDetailDates[$0].originalDate }

                    for i in comboRange {
                        let gameDate = allGameDetailDates[i]
                        let yearMonth = String(gameDate.originalDate.prefix(7))
                        let day = String(gameDate.originalDate.suffix(2))
                        
                        guard var monthDates = state.dateUserStatusInfos[yearMonth],
                              let dayIndex = monthDates.firstIndex(where: { $0.date == day }),
                              let userStatus = monthDates[dayIndex].userStatus[0] else { continue }
                        
                        monthDates[dayIndex].userStatus[0] = GameDetailUserStatus(
                            userID: userStatus.userID,
                            isCompleted: true,
                            streakCount: userStatus.streakCount,
                            isCombo: true
                        )
                        
                        state.dateUserStatusInfos[yearMonth] = monthDates
                    }
                } else {
                    todayDate.userStatus[0] = GameDetailUserStatus(
                        userID: myUserStatus.userID,
                        isCompleted: true,
                        streakCount: myUserStatus.streakCount,
                        isCombo: false
                    )
                    
                    currentMonthGameDetailDates[todaySameDateIndex] = todayDate
                    state.dateUserStatusInfos[state.todayYearMonth] = currentMonthGameDetailDates
                }
            }
        }
                
        state.shouldReloadToday = true
    }
}
