//
//  GameOhterSettingView.swift
//  GameDetail
//
//  Created by 김동준 on 9/21/25
//

import SwiftUI
import DesignSystem
import Domain

struct GameOhterSettingView: View {
    private let gameCategory: GameCategory?
    private let privateRoomPassword: String?
    private let isPrivateRoom: Bool
    private let isReminderSettingHidden: Bool
    private let canChangeSetting: Bool
    
    private let categoryButtonAction: (() -> Void)?
    private let privateRoomCodeAreaButtonAction: (() -> Void)?
    private let privateRoomButtonAction: () -> Void
    
    init(
        gameCategory: GameCategory?,
        privateRoomPassword: String? = nil,
        isPrivateRoom: Bool,
        isReminderSettingHidden: Bool,
        canChangeSetting: Bool,
        categoryButtonAction: (() -> Void)? = nil,
        privateRoomCodeAreaButtonAction: (() -> Void)? = nil,
        privateRoomButtonAction: @escaping () -> Void
    ) {
        self.gameCategory = gameCategory
        self.privateRoomPassword = privateRoomPassword
        self.isPrivateRoom = isPrivateRoom
        self.isReminderSettingHidden = isReminderSettingHidden
        self.canChangeSetting = canChangeSetting
        self.categoryButtonAction = categoryButtonAction
        self.privateRoomCodeAreaButtonAction = privateRoomCodeAreaButtonAction
        self.privateRoomButtonAction = privateRoomButtonAction
    }
    
    var body: some View {
        VStack(spacing: 6) {
            OText(
                "기타 설정",
                token: .subtitle_02
            )
            .hPadding(16)
            .greedyWidth(.leading)
            VStack(spacing: 0) {
                if isShowCategoryView {
                    gameCategoryView
                    StrokeDivider(color: OColors.stroke02.swiftUIColor)
                }

                if !isReminderSettingHidden {
                    OInputToggleField(
                        title: "리마인드 알림",
                        additionalInfo: "오전 9:00",
                        isSelected: .constant(false)
                    )
                    StrokeDivider(color: OColors.stroke02.swiftUIColor)
                }
                privateRoomSection
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
}

private extension GameOhterSettingView {
    var isShowCategoryView: Bool {
        return canChangeSetting || gameCategory != nil
    }
    
    var gameCategoryView: some View {
        OInputField(
            title: "대국 카테고리",
            value: selectedCategoryString,
            arrowVisible: canChangeSetting,
            buttonAction: {
                categoryButtonAction?()
            }
        )
    }

    var selectedCategoryString: String {
        if let category = gameCategory {
            return category.category
        } else {
            return "선택"
        }
    }
}

private extension GameOhterSettingView {
    @ViewBuilder
    var privateRoomSection: some View  {
        if canChangeSetting {
            privateRoomToggleView
        } else {
            privateRoomInfoView
        }
    }
    
    var privateRoomToggleView: some View {
        OInputToggleField(
            title: "비공개",
            selectAreaAction: {
                privateRoomCodeAreaButtonAction?()
            },
            additionalInfo: "비밀번호 : \(privateRoomPassword ?? "-")",
            isSelected: Binding(
                get: { isPrivateRoom },
                set: { _ in
                    privateRoomButtonAction()
                }
            )
        )
    }
    
    var privateRoomInfoView: some View {
        HStack(spacing: 8) {
            OText(
                "비공개",
                token: .subtitle_03
            )
            Spacer()
            Button {
                UIPasteboard.general.string = privateRoomText
                privateRoomButtonAction()
            } label: {
                OText(
                    privateRoomText,
                    token: .subtitle_03,
                    color: OColors.text02.swiftUIColor,
                    isUnderline: isPrivateRoom
                )
            }
            .disabled(!isPrivateRoom)
        }.padding(16)
    }
    
    var privateRoomText: String {
        isPrivateRoom ? (privateRoomPassword ?? "-") : "공개"
    }
}
