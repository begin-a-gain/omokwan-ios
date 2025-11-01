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
    private let roomInfo: GameRoomInformation
    private let categories: [GameCategory]
    let buttonAction: () -> Void
    
    init(
        roomInfo: GameRoomInformation,
        categories: [GameCategory],
        buttonAction: @escaping () -> Void
    ) {
        self.roomInfo = roomInfo
        self.categories = categories
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
            getLockImage(roomInfo.isPublic)
                .resizedToFit(16, 16)
                .vPadding(2)
            
            OText(
                roomInfo.name,
                token: .title_02,
                color: OColors.text01.swiftUIColor
            ).greedyWidth(.leading)
        }
    }
    
    func getLockImage(_ isPublic: Bool) -> Image {
        isPublic
        ? OImages.icLockOpen.swiftUIImage
        : OImages.icLockClosed.swiftUIImage
    }
}

// MARK: info section
private extension GameRoomCardView {
    var infoSection: some View {
        HStack(spacing: 8) {
            peopleCountView
            
            if let categoryId = roomInfo.categoryId,
               let category = categories.category(for: categoryId) {
                verticalDividerView
                categoryView(category)
            }
            
            verticalDividerView
            matchDayView
        }.greedyWidth(.leading)
    }
    
    var peopleCountView: some View  {
        OText(
            "\(roomInfo.participants)/\(roomInfo.maxParticipants)명",
            token: .caption,
            color: OColors.text01.swiftUIColor
        )
    }
    
    func categoryView(_ category: GameCategory) -> some View {
        OText(
            "#\(category.category)",
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
            "대국+\(roomInfo.ongoingDays)일 째",
            token: .caption,
            color: OColors.text01.swiftUIColor
        )
    }
}

// MARK: host section
private extension GameRoomCardView {
    var hostSection: some View {
        OText(
            "\(roomInfo.hostName)님의 대국",
            token: .caption,
            color: OColors.text01.swiftUIColor
        ).greedyWidth(.leading)
    }
}

private extension GameRoomCardView {
    var buttonTitle: String {
        switch roomInfo.joinStatus {
        case .possible, .impossible:
            "참여하기"
        case .inProgress:
            "참여중"
        }
    }
    
    var buttonColor: Color {
        switch roomInfo.joinStatus {
        case .possible:
            OColors.uiPrimary.swiftUIColor
        case .impossible, .inProgress:
            OColors.uiDisable01.swiftUIColor
        }
    }
    
    var textColor: Color {
        switch roomInfo.joinStatus {
        case .possible:
            OColors.ui01.swiftUIColor
        case .impossible, .inProgress:
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
        }.disabled(roomInfo.joinStatus != .possible)
    }
}
