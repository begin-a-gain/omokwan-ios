//
//  MyGameStone.swift
//  MyGame
//
//  Created by 김동준 on 12/7/24
//

import SwiftUI
import DesignSystem
import Domain

struct MyGameStone: View {
    let fullRectSize: CGFloat
    let stoneSize: CGFloat
    let myGameCompleteStatus: MyGameCompleteStatus
    let omokStoneType: OmokStoneType
    
    init(
        fullRectSize: CGFloat,
        stoneSize: CGFloat,
        myGameCompleteStatus: MyGameCompleteStatus
    ) {
        self.fullRectSize = fullRectSize
        self.stoneSize = stoneSize
        self.myGameCompleteStatus = myGameCompleteStatus
        
        self.omokStoneType = switch myGameCompleteStatus {
        case .complete: .primary
        case .inComplete, .inCompleteWithSkip: .white
        }
    }
    
    var body: some View {
        ZStack {
            OmokStone(
                stoneSize: stoneSize,
                stoneType: omokStoneType
            )
            stoneStatusView
        }
    }
}

private extension MyGameStone {
    var stoneStatusView: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            
            ZStack {
                Circle()
                    .fill(stoneStatusButtonBackgroundColor)
                    .padding(.trailing, 4)
                    .padding(.top, 4)
                    .frame(fullRectSize / 3, fullRectSize / 3)
                    .modifier(
                        MyGameStoneStatusViewModifier(
                            myGameCompleteStatus: myGameCompleteStatus,
                            size: fullRectSize / 3
                        )
                    )
                stoneStatusButtonContent
                    .padding(.trailing, 4)
                    .padding(.top, 4)
            }
        }.frame(fullRectSize, fullRectSize)
    }
    
    @ViewBuilder
    var stoneStatusButtonContent: some View {
        switch myGameCompleteStatus {
        case .complete:
            OImages.icCheck.swiftUIImage
                .renderingMode(.template)
                .resizedToFit(24, 24)
                .foregroundColor(OColors.icon01.swiftUIColor)
        case .inComplete:
            OText(
                "완료하기",
                token: .subtitle_01,
                color: OColors.textOnDisable.swiftUIColor
            ).frame(fullRectSize / 3, fullRectSize / 3)
        case .inCompleteWithSkip:
            OText(
                "미완료",
                token: .subtitle_01
            ).frame(fullRectSize / 3, fullRectSize / 3)
        }
    }
    
    var stoneStatusButtonBackgroundColor: Color {
        switch myGameCompleteStatus {
        case .complete:
            OColors.uiPrimary.swiftUIColor
        case .inComplete:
            OColors.uiDisable01.swiftUIColor
        case .inCompleteWithSkip:
            OColors.uiDisable02.swiftUIColor
        }
    }
}
