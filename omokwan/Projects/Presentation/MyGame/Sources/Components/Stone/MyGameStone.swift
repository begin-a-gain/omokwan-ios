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
    let omokStoneType: OmokStoneType
    let stoneTapAction: (MyGameModel) -> Void
    
    init(
        fullRectSize: CGFloat,
        stoneSize: CGFloat,
        item: MyGameModel,
        stoneTapAction: @escaping (MyGameModel) -> Void
    ) {
        self.fullRectSize = fullRectSize
        self.stoneSize = stoneSize
        self.item = item
        self.stoneTapAction = stoneTapAction
        
        self.omokStoneType = switch item.myGameCompleteStatus {
        case .complete: .primary
        case .inComplete, .inCompleteWithSkip: .white
        }
    }
    
    var body: some View {
        ZStack {
            Button {
                stoneTapAction(item)
            } label: {
                OmokStone(
                    stoneSize: stoneSize,
                    stoneType: omokStoneType
                ).overlay {
                    stoneContents
                }
            }
            
            stoneStatusView
        }
    }
}

private extension MyGameStone {
    var stoneContents: some View {
        VStack(spacing: 0) {
            lockImage
                .resizedToFit(16, 16)
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
