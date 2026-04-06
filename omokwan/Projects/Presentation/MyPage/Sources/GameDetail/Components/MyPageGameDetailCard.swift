//
//  MyPageGameDetailCard.swift
//  MyPage
//
//  Created by 김동준 on 1/14/26
//

import SwiftUI
import DesignSystem
import Domain

struct MyPageGameDetailCard: View {
    let isLoading: Bool
    let roomInfo: MyPageGameDetailModel
    let isButtonDisabled: Bool
    let buttonAction: (() -> Void)?
    
    init(
        isLoading: Bool,
        roomInfo: MyPageGameDetailModel,
        isButtonDisabled: Bool,
        buttonAction: (() -> Void)? = nil
    ) {
        self.isLoading = isLoading
        self.roomInfo = roomInfo
        self.isButtonDisabled = isButtonDisabled
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button {
            buttonAction?()
        } label: {
            infoView
                .padding(20)
                .background(OColors.uiBackground.swiftUIColor)
        }.disabled(isButtonDisabled)
    }
}

private extension MyPageGameDetailCard {
    var infoView: some View {
        VStack(spacing: 8) {
            titleSection
            infoSection
            if let dayDescription = roomInfo.dayDescription {
                daySection(dayDescription)
            }
        }
    }
}

private extension MyPageGameDetailCard {
    var titleSection: some View {
        HStack(spacing: 8) {
            OText(
                roomInfo.title,
                token: .title_02,
                color: OColors.text01.swiftUIColor
            ).greedyWidth(.leading)
        }
        .shimmer(isLoading, cornerRadius: 4)
    }
}

private extension MyPageGameDetailCard {
    var infoSection: some View {
        HStack(spacing: 8) {
            participateDayView
            verticalDividerView
            comboView
            verticalDividerView
            stoneView
        }
        .shimmer(isLoading, cornerRadius: 4)
        .greedyWidth(.leading)
    }
    
    var participateDayView: some View  {
        HStack(spacing: 8) {
            OText(
                "대국 참여 일 수",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
            OText(
                "+\(roomInfo.ongoingDays)",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
        }
    }
    
    var comboView: some View  {
        HStack(spacing: 8) {
            OText(
                "콤보",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
            OText(
                "\(roomInfo.combo)",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
        }
    }
    
    var stoneView: some View  {
        HStack(spacing: 8) {
            OText(
                "오목알",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
            OText(
                "\(roomInfo.stone)",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
        }
    }
    
    var verticalDividerView: some View {
        Rectangle()
            .frame(width: 1, height: 12)
            .foregroundColor(OColors.stroke02.swiftUIColor)
    }
}

private extension MyPageGameDetailCard {
    func daySection(_ dayDescription: String) -> some View {
        HStack(spacing: 8) {
            OText(
                "요일",
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
            OText(
                dayDescription,
                token: .caption,
                color: OColors.text01.swiftUIColor
            )
        }.greedyWidth(.leading)
    }
}
