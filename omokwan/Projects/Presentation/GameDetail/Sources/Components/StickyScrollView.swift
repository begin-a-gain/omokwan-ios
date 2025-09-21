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

struct StickyScrollView: View {
    private let dateDictionary: [String: [Date]]
    private let hPadding: CGFloat
    private let availableWidth: CGFloat
    private let textWidth: CGFloat
    private let stoneRowWidth: CGFloat
    private let itemSize: CGFloat
    
    init(
        dateDictionary: [String : [Date]],
        availableWidth: CGFloat,
        hPadding: CGFloat
    ) {
        self.dateDictionary = dateDictionary
        self.availableWidth = availableWidth
        self.hPadding = hPadding
        self.textWidth = GameDetailConstants.calendarDayTextWidthRatio * availableWidth
        self.stoneRowWidth = GameDetailConstants.stoneRowWidthRatio * availableWidth
        self.itemSize = stoneRowWidth / 5
    }
    
    var body : some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    let keys = dateDictionary.keys.sorted()

                    ForEach(Array(zip(keys.indices, keys)), id: \.1) { index, key in
                        if let dates = dateDictionary[key] {
                            Section(header: monthHeaderView(key)) {
                                monthSectionBody(
                                    headerString: key,
                                    dates: dates
                                )
                                .padding(.bottom, index == (dateDictionary.count - 1) ? 0 : 20)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(OColors.uiBackground.swiftUIColor)
                            )
                        }
                    }
                }
            }
            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    let today = viewStore.now.seoulNow.formattedString(format: DateFormatConstants.scrollCalendarFormat)
//                    scrollProxy.scrollTo(today, anchor: .top)
//                }
            }
        }
    }
}

private extension StickyScrollView {
    func monthHeaderView(_ headerString: String) -> some View {
        ZStack(alignment: .bottom) {
            OText(
                headerString,
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
    
    func monthSectionBody(
        headerString: String,
        dates: [Date]
    ) -> some View {
        VStack(spacing: 0) {
            ForEach(dates, id: \.self) { date in
                HStack(spacing: 0) {
                    dateView(date)
                    
                    HStack(spacing: 0) {
                        ForEach(0..<5) { index in
                            if index == 0 {
                                ZStack {
                                    OmokStone(
                                        stoneSize: itemSize - 10,
                                        stoneType: .primary
                                    )
                                    CrossLineView(
                                        crossLineSize: itemSize,
                                        circleSize: itemSize - 10,
                                        strokeColor: OColors.strokePrimaryOpa40.swiftUIColor,
                                        hasData: true
                                    )
                                }
                                .frame(width: itemSize, height: itemSize)
                                .background(OColors.oPrimary.swiftUIColor.opacity(0.1))
                            } else {
                                ZStack {
                                    CrossLineView(
                                        crossLineSize: itemSize,
                                        strokeColor: OColors.stroke02.swiftUIColor,
                                        hasData: false
                                    )
                                }
                                .frame(width: itemSize, height: itemSize)
                            }
                            
                        }
                    }
                }
                .id(
                    date.formattedString(
                        format: DateFormatConstants.scrollCalendarFormat
                    )
                )
            }
        }
        .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
        .hPadding(20)
    }
    
    func dateView(_ date: Date) -> some View {
        let str = date.formattedString(format: DateFormatConstants.detailGameSectionRowDateFormat)
        
        return Group {
            if str == "10" {
                VStack(spacing: 0) {
                    OText(
                        "금",
                        token: .subtitle_03,
                        color: OColors.text01.swiftUIColor
                    )
                    OText(
                        str,
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
                    str,
                    token: .subtitle_03,
                    color: OColors.text01.swiftUIColor
                )
                .frame(width: textWidth, height: itemSize)
                .background(OColors.ui02.swiftUIColor)
            }
        }
    }
}

