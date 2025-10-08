//
//  CalendarRowSectionView.swift
//  GameDetail
//
//  Created by 김동준 on 10/5/25
//

import SwiftUI
import DesignSystem
import Domain

struct CalendarRowSectionView: View {
    private let gameDetailDate: GameDetailDate
    private let isToday: Bool
    private let todayString: String
    private let availableWidth: CGFloat
    private let headerString: String
    private let isLastItem: Bool
    private let itemSize: CGFloat
    private let textWidth: CGFloat
    
    init(
        gameDetailDate: GameDetailDate,
        isToday: Bool,
        todayString: String,
        availableWidth: CGFloat,
        headerString: String,
        isLastItem: Bool
    ) {
        self.gameDetailDate = gameDetailDate
        self.isToday = isToday
        self.todayString = todayString
        self.availableWidth = availableWidth
        self.headerString = headerString
        self.isLastItem = isLastItem
        self.textWidth = GameDetailConstants.calendarDayTextWidthRatio * availableWidth
        let stoneRowWidth = GameDetailConstants.stoneRowWidthRatio * availableWidth
        self.itemSize = stoneRowWidth / 5
    }
    
    var body: some View {
        HStack(spacing: 0) {
            CalendarDateView(
                gameDetailDate: gameDetailDate,
                isToday: isToday,
                todayString: todayString,
                availableWidth: availableWidth,
                textWidth: textWidth,
                itemSize: itemSize
            )
            
            HStack(spacing: 0) {
                ForEach(0..<gameDetailDate.userStatus.count, id: \.self) { index in
                    CalendarStoneView(
                        gameDetailDate: gameDetailDate,
                        index: index,
                        isToday: isToday,
                        itemSize: itemSize
                    )
                }
            }
        }
        .background(OColors.ui02.swiftUIColor)
        .padding(.horizontal, 20)
        .cornerRadius(isLastItem ? 8 : 0, corners: [.bottomLeft, .bottomRight])
    }
}
