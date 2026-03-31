//
//  CalendarStoneView.swift
//  GameDetail
//
//  Created by 김동준 on 10/5/25
//

import SwiftUI
import DesignSystem
import Domain

struct CalendarStoneView: View {
    private let gameDetailDate: GameDetailDate
    private let index: Int
    private let isToday: Bool
    private let itemSize: CGFloat
    
    init(
        gameDetailDate: GameDetailDate,
        index: Int,
        isToday: Bool,
        itemSize: CGFloat
    ) {
        self.gameDetailDate = gameDetailDate
        self.index = index
        self.isToday = isToday
        self.itemSize = itemSize
    }
    
    var body: some View {
        let me = index == 0
        
        ZStack {
            UserStatusCrossLineView(
                userStatus: gameDetailDate.userStatus[index],
                me: me,
                size: itemSize,
                isToday: isToday
            )
            UserStatusStoneView(
                userStatus: gameDetailDate.userStatus[index],
                me: me,
                itemSize: itemSize,
                isToday: isToday
            )
        }
        .frame(width: itemSize, height: itemSize)
        .background(
            me
            ? OColors.oPrimary.swiftUIColor.opacity(0.1)
            : .clear
        )
    }
}
