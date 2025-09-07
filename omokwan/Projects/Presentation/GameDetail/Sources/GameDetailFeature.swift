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

@Reducer
public struct GameDetailFeature {
    public init() {}
    
    public struct State: Equatable {
        public init(gameID: Int, gameTitle: String) {
            self.gameID = gameID
            self.gameTitle = gameTitle
        }
        
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
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("## dateDictionary:\(state.dateDictionary)")
                return .none
            case .navigateToBack:
                return .none
            case .menuButtonTapped:
                return .none
            }
        }
    }
}
