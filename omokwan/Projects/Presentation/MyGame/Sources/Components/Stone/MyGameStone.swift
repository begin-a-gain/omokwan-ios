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
    let item: MyGameModel
    
    init(
        fullRectSize: CGFloat,
        stoneSize: CGFloat,
        item: MyGameModel
    ) {
        self.fullRectSize = fullRectSize
        self.stoneSize = stoneSize
        self.item = item
    }
    
    var body: some View {
        ZStack {
            stone
            stoneStatusButton
        }
    }
}

// MARK: 오목돌에 관한 View
private extension MyGameStone {
    var stone: some View  {
        Button {
            
        } label: {
            Circle()
                .fill(
                    LinearGradient(
                        stops: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(stoneOpacity)
                .frame(width: stoneSize, height: stoneSize)
                .shadow(
                    color: stoneShadowColor,
                    radius: 10,
                    x: 0, y: 0
                )
                .modifier(MyGameStoneModifier(myGameCompleteStatus: item.myGameCompleteStatus))
                .overlay(alignment: .top) {
                    stoneContents
                }
        }
    }
    
    var gradientColors: [Gradient.Stop] {
        switch item.myGameCompleteStatus {
        case .complete:
            return [
                Gradient.Stop(color: OColors.oWhite.swiftUIColor, location: MyGameConstants.linearGradientStartPoint),
                Gradient.Stop(color: OColors.uiPrimary.swiftUIColor, location: MyGameConstants.linearGradientMiddlePoint),
                Gradient.Stop(color: OColors.uiLinearGradientEndPoint.swiftUIColor, location: MyGameConstants.linearGradientEndPoint)
            ]
        case .inComplete, .inCompleteWithSkip:
            return [
                Gradient.Stop(color: OColors.oWhite.swiftUIColor, location: MyGameConstants.linearGradientStartPoint),
                Gradient.Stop(color: OColors.gray600.swiftUIColor, location: MyGameConstants.linearGradientMiddlePoint),
                Gradient.Stop(color: OColors.oWhite.swiftUIColor, location: MyGameConstants.linearGradientEndPoint)
            ]
        }
    }
    
    var stoneOpacity: CGFloat {
        switch item.myGameCompleteStatus {
        case .complete: 0.5
        case .inComplete, .inCompleteWithSkip: 0.2
        }
    }
    
    var stoneShadowColor: Color {
        switch item.myGameCompleteStatus {
        case .complete:
            OColors.uiPrimary.swiftUIColor// .opacity(0.7)
        case .inComplete, .inCompleteWithSkip:
            OColors.oBlack.swiftUIColor
//            OColors.uiInCompletedStoneShadow.swiftUIColor
        }
    }
}

// MARK: 오목돌의 내용
private extension MyGameStone {
    var stoneContents: some View {
        VStack(spacing: 0) {
            lockImage
                .resizedToFit(16, 16)
                .padding(.top, 26)
                .padding(.bottom, 12)
            
            OText(
                item.name,
                token: .title_02,
                color: OColors.text01.swiftUIColor,
                lineLimit: 2
            )
            .padding(.bottom, 6)
            
            OText(
                "대국 +\(item.onGoingDays)일 째",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
            .padding(.bottom, 2)
            
            OText(
                "\(item.participants)/\(item.maxParticipants) 명",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
        }
        .greedyWidth()
        .hPadding(12)
    }
    
    var lockImage: Image {
        item.isPrivateRoom
        ? OImages.icLockClosed.swiftUIImage
        : OImages.icLockOpen.swiftUIImage
    }
}

// MARK: 오목돌의 status (완료, 미완료와 같은 상태)에 대한 View
private extension MyGameStone {
    var stoneStatusButton: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            
            ZStack {
                Circle()
                    .fill(stoneStatusButtonBackgroundColor)
                    .padding(.trailing, 4)
                    .padding(.top, 4)
                    .frame(fullRectSize / 3, fullRectSize / 3)
                    .modifier(
                        MyGameStoneStatusButtonModifier(
                            myGameCompleteStatus: item.myGameCompleteStatus,
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
        switch item.myGameCompleteStatus {
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
        switch item.myGameCompleteStatus {
        case .complete:
            OColors.uiPrimary.swiftUIColor
        case .inComplete:
            OColors.uiDisable01.swiftUIColor
        case .inCompleteWithSkip:
            OColors.uiDisable02.swiftUIColor
        }
    }
}
