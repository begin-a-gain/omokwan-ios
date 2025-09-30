//
//  GameDefaultSettingView.swift
//  GameDetail
//
//  Created by 김동준 on 9/21/25
//

import SwiftUI
import DesignSystem

struct GameDefaultSettingView: View {
    private let maxNumOfPeople: Int
    private let canChangeMaxNumOfPeopleSetting: Bool
    private let maxNumOfPeopleButtonAction: (() -> Void)?
    
    init(
        maxNumOfPeople: Int,
        canChangeMaxNumOfPeopleSetting: Bool,
        maxNumOfPeopleButtonAction: (() -> Void)? = nil
    ) {
        self.maxNumOfPeople = maxNumOfPeople
        self.canChangeMaxNumOfPeopleSetting = canChangeMaxNumOfPeopleSetting
        self.maxNumOfPeopleButtonAction = maxNumOfPeopleButtonAction
    }
    
    var body: some View {
        VStack(spacing: 6) {
            OText(
                "기본 설정",
                token: .subtitle_02
            )
            .hPadding(16)
            .greedyWidth(.leading)
            VStack(spacing: 0) {
                gameDaysElapsedView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                gameCodeView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                repeatDayView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                maxNumOfPeopleView
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
}

private extension GameDefaultSettingView {
    var gameDaysElapsedView: some View {
        HStack(spacing: 0) {
            OText(
                "대국 진행 일 수",
                token: .subtitle_03
            )
            Spacer()
            OText(
                "+123일 째",
                token: .subtitle_03,
                color: OColors.text02.swiftUIColor
            )
        }
        .padding(16)
    }
    
    var gameCodeView: some View {
        HStack(spacing: 0) {
            OText(
                "대국코드",
                token: .subtitle_03
            )
            Spacer()
            Button {
                UIPasteboard.general.string = "XALXBB6ZU2"
            } label: {
                OText(
                    "XALXBB6ZU2",
                    token: .subtitle_03,
                    color: OColors.text02.swiftUIColor,
                    isUnderline: true
                )
            }
        }
        .padding(16)
    }
    
    var repeatDayView: some View {
        HStack(spacing: 0) {
            OText(
                "반복 요일",
                token: .subtitle_03
            )
            Spacer()
            OText(
                "월, 수, 금",
                token: .subtitle_03,
                color: OColors.text02.swiftUIColor
            )
        }
        .padding(16)
    }
    
    var maxNumOfPeopleView: some View {
        OInputField(
            title: "최대 인원 수",
            value: "\(maxNumOfPeople)",
            arrowVisible: canChangeMaxNumOfPeopleSetting,
            buttonAction: {
                maxNumOfPeopleButtonAction?()
            }
        )
    }
}
