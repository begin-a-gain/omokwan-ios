//
//  StickyScrollView.swift
//  GameDetail
//
//  Created by 김동준 on 9/8/25
//

import SwiftUI
import DesignSystem
import Foundation
import Util
import Domain

struct StickyScrollView: View {
    private let dateUserStatusInfos: [String: [GameDetailDate]]
    private let hPadding: CGFloat
    private let todayString: String
    private let availableWidth: CGFloat
    private let textWidth: CGFloat
    private let stoneRowWidth: CGFloat
    private let itemSize: CGFloat
    private let todayYearMonth: String
    private let todayOnlyDay: String
    
    init(
        dateUserStatusInfos: [String : [GameDetailDate]],
        availableWidth: CGFloat,
        hPadding: CGFloat,
        todayString: String
    ) {
        self.dateUserStatusInfos = dateUserStatusInfos
        self.availableWidth = availableWidth
        self.hPadding = hPadding
        self.todayString = todayString
        self.textWidth = GameDetailConstants.calendarDayTextWidthRatio * availableWidth
        self.stoneRowWidth = GameDetailConstants.stoneRowWidthRatio * availableWidth
        self.itemSize = stoneRowWidth / 5
        let nowDateString = Date().formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
        self.todayYearMonth = String(nowDateString.prefix(7))
        self.todayOnlyDay = String(nowDateString.suffix(2))
    }
    
    var body : some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    let keys = dateUserStatusInfos.keys.sorted(by: >)

                    ForEach(Array(zip(keys.indices, keys)), id: \.1) { index, key in
                        if let dateUserStatusInfo = dateUserStatusInfos[key] {
                            Section(header: calendarHeaderView(key)) {
                                calendarBodyView(
                                    headerString: key,
                                    dateUserStatusInfo: dateUserStatusInfo
                                )
                                .padding(.bottom, index == (dateUserStatusInfos.count - 1) ? 0 : 20)
                            }
                            .id(key)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(OColors.uiBackground.swiftUIColor)
                            )
                        }
                    }
                }
            }
            .onChange(of: dateUserStatusInfos) { oldValue, newValue in
                if oldValue.isEmpty && !newValue.isEmpty {
                    scrollToTodayWithPreload(scrollProxy)
                }
            }
        }
    }
    
    private func scrollToTodayWithPreload(_ proxy: ScrollViewProxy) {
        let sectionId = todayYearMonth
        let todayId = todayYearMonth + todayOnlyDay
        
        proxy.scrollTo(sectionId, anchor: .top)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeInOut(duration: 0.3)) {
                proxy.scrollTo(todayId, anchor: .center)
            }
        }
    }
}

private extension StickyScrollView {
    func calendarHeaderView(_ headerString: String) -> some View {
        ZStack(alignment: .bottom) {
            OText(
                formatYearMonth(headerString),
                token: .title_02,
                color: OColors.text01.swiftUIColor
            )
            .greedyWidth()
            .vPadding(8)
            .background(OColors.ui02.swiftUIColor)
            
            Rectangle()
                .height(2)
                .greedyWidth()
                .foregroundStyle(OColors.stroke02.swiftUIColor)
        }
        .cornerRadius(8, corners: [.topLeft, .topRight])
        .hPadding(20)
    }
    
    func formatYearMonth(_ input: String) -> String {
        let parts = input.split(separator: "-")
        guard parts.count == 2,
              let year = parts.first,
              let month = parts.last else {
            return input
        }
        return "\(year). \(month)월"
    }
    
    func calendarBodyView(
        headerString: String,
        dateUserStatusInfo: [GameDetailDate]
    ) -> some View {
        let isTodayYearMonth = headerString == todayYearMonth
        
        return VStack(spacing: 0) {
            ForEach(dateUserStatusInfo, id: \.self) { element in
                HStack(spacing: 0) {
                    let isToday = element.date == todayOnlyDay && isTodayYearMonth
                    dateView(element, isToday)
                    
                    HStack(spacing: 0) {
                        ForEach(0..<element.userStatus.count, id: \.self) { index in
                            stoneView(
                                element: element,
                                index: index,
                                isToday: isToday
                            )
                        }
                    }
                }
                .id(headerString + element.date)
            }
        }
        .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
        .hPadding(20)
    }
    
    func dateView(_ gameDetailDate: GameDetailDate, _ isToday: Bool) -> some View {
        return Group {
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
                .frame(width: GameDetailConstants.calendarDayTextBorderWidthRadio * textWidth)
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

private extension StickyScrollView {
    @ViewBuilder
    func stoneView(
        element: GameDetailDate,
        index: Int,
        isToday: Bool
    ) -> some View {
        let me = index == 0
        
        ZStack {
            UserStatusStoneView(
                userStatus: element.userStatus[index],
                me: me,
                itemSize: itemSize,
                isToday: isToday
            )
            UserStatusCrossLineView(
                userStatus: element.userStatus[index],
                me: me,
                size: itemSize,
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
