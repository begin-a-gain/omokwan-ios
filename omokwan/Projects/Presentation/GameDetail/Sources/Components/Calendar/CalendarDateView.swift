//
//  CalendarDateView.swift
//  GameDetail
//
//  Created by 김동준 on 10/5/25
//

import SwiftUI
import DesignSystem
import Domain

struct CalendarDateView: View {
    private let gameDetailDate: GameDetailDate
    private let isToday: Bool
    private let todayString: String
    private let textWidth: CGFloat
    private let itemSize: CGFloat
    private let todayTextWidth: CGFloat
    
    init(
        gameDetailDate: GameDetailDate,
        isToday: Bool,
        todayString: String,
        availableWidth: CGFloat,
        textWidth: CGFloat,
        itemSize: CGFloat
    ) {
        self.gameDetailDate = gameDetailDate
        self.isToday = isToday
        self.todayString = todayString
        self.textWidth = textWidth
        self.itemSize = itemSize
        self.todayTextWidth = GameDetailConstants.calendarDayTextBorderWidthRadio * textWidth
    }
    
    var body: some View {
        Group {
            if isToday {
                VStack(spacing: 0) {
                    OText(
                        todayString,
                        token: .subtitle_03,
                        color: OColors.text01.swiftUIColor
                    )
                    OText(
                        gameDetailDate.date,
                        token: .headline,
                        color: OColors.text01.swiftUIColor
                    )
                }
                .frame(width: todayTextWidth)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(OColors.oWhite.swiftUIColor)
                )
                .frame(width: textWidth, height: itemSize)
                .background(OColors.ui02.swiftUIColor)
            } else {
                OText(
                    gameDetailDate.date,
                    token: .subtitle_03,
                    color: OColors.text01.swiftUIColor
                )
                .frame(width: textWidth, height: itemSize)
                .background(OColors.ui02.swiftUIColor)
            }
        }
    }
}
