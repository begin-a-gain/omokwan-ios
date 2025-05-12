//
//  GameRoomCardView.swift
//  MyGameParticipate
//
//  Created by 김동준 on 4/28/25
//

import SwiftUI
import DesignSystem
import Domain

struct GameRoomCardView: View {
    let roomInfo: GameRoomInformation
    let buttonAction: () -> Void
    
    init(
        roomInfo: GameRoomInformation,
        buttonAction: @escaping () -> Void
    ) {
        self.roomInfo = roomInfo
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        HStack(spacing: 34) {
            infoView
            buttonView
        }
        .padding(20)
        .background(OColors.uiBackground.swiftUIColor)
    }
}

private extension GameRoomCardView {
    var infoView: some View {
        VStack(spacing: 8) {
            titleSection
            infoSection
            hostSection
        }
    }
}

// MARK: title section
private extension GameRoomCardView {
    var titleSection: some View {
        HStack(spacing: 8) {
            getLockImage(roomInfo.isPrivateRoom)
                .resizedToFit(16, 16)
                .vPadding(2)
            
            OText(
                roomInfo.title,
                token: .title_02,
                color: OColors.text01.swiftUIColor
            ).greedyWidth(.leading)
        }
    }
    
    func getLockImage(_ isPrivate: Bool) -> Image {
        isPrivate
        ? OImages.icLockClosed.swiftUIImage
        : OImages.icLockOpen.swiftUIImage
    }
}

// MARK: info section
private extension GameRoomCardView {
    var infoSection: some View {
        HStack(spacing: 8) {
            peopleCountView
            
            if let category = roomInfo.category {
                verticalDividerView
                categoryView(category)
            }
            
            verticalDividerView
            matchDayView
        }.greedyWidth(.leading)
    }
    
    var peopleCountView: some View  {
        OText(
            "\(roomInfo.currentNumOfPeople)/\(roomInfo.maxNumOfPeople)명",
            token: .caption,
            color: OColors.text01.swiftUIColor
        )
    }
    
    func categoryView(_ category: GameCategory) -> some View {
        OText(
            "#\(category.rawValue)",
            token: .caption,
            color: OColors.text01.swiftUIColor
        )
    }
    
    var verticalDividerView: some View {
        Rectangle()
            .frame(width: 1, height: 12)
            .foregroundColor(OColors.stroke02.swiftUIColor)
    }
    
    var matchDayView: some View {
        OText(
            "대국+1일 째",
//            "대국+\(roomInfo.createRoomDate.timeIntervalSinceNow)일 째",
            token: .caption,
            color: OColors.text01.swiftUIColor
        )
    }
}

// MARK: host section
private extension GameRoomCardView {
    var hostSection: some View {
        OText(
            roomInfo.hostName,
            token: .caption,
            color: OColors.text01.swiftUIColor
        ).greedyWidth(.leading)
    }
}

private extension GameRoomCardView {
    var buttonTitle: String {
        switch roomInfo.roomStatus {
        case .participating:
            "참여중"
        case .available, .unavailable:
            "참여하기"
        }
    }
    
    var buttonColor: Color {
        switch roomInfo.roomStatus {
        case .available:
            OColors.uiPrimary.swiftUIColor
        case .participating, .unavailable:
            OColors.uiDisable01.swiftUIColor
        }
    }
    
    var textColor: Color {
        switch roomInfo.roomStatus {
        case .available:
            OColors.ui01.swiftUIColor
        case .unavailable, .participating:
            OColors.textOnDisable.swiftUIColor
        }
    }
    
    var buttonView: some View {
        Button {
            buttonAction()
        } label: {
            OText(
                buttonTitle,
                token: .subtitle_02,
                color: textColor
            )
            .vPadding(10)
            .hPadding(16)
            .background(buttonColor)
            .cornerRadius(8)
        }.disabled(roomInfo.roomStatus != .available)
    }
}
