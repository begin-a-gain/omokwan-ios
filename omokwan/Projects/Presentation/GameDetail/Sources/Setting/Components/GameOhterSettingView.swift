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
    private let isPrivateRoomSelected: Bool
    
    private let categoryButtonAction: (() -> Void)?
    private let privateRoomCodeAreaButtonAction: (() -> Void)?
    private let privateRoomToggleButtonAction: () -> Void
    
    init(
        gameCategory: GameCategory?,
        privateRoomPassword: String? = nil,
        isPrivateRoomSelected: Bool,
        categoryButtonAction: (() -> Void)? = nil,
        privateRoomCodeAreaButtonAction: (() -> Void)? = nil,
        privateRoomToggleButtonAction: @escaping () -> Void
    ) {
        self.gameCategory = gameCategory
        self.privateRoomPassword = privateRoomPassword
        self.isPrivateRoomSelected = isPrivateRoomSelected
        self.categoryButtonAction = categoryButtonAction
        self.privateRoomCodeAreaButtonAction = privateRoomCodeAreaButtonAction
        self.privateRoomToggleButtonAction = privateRoomToggleButtonAction
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
                gameCategoryView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                OInputToggleField(
                    title: "리마인드 알림",
                    additionalInfo: "오전 9:00",
                    isSelected: .constant(false)
                )
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                OInputToggleField(
                    title: "비공개",
                    selectAreaAction: {
                        privateRoomCodeAreaButtonAction?()
                    },
                    additionalInfo: "코드 : \(privateRoomPassword ?? "-")",
                    isSelected: Binding(
                        get: { isPrivateRoomSelected },
                        set: { _ in
                            privateRoomToggleButtonAction()
                        }
                    )
                )

            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
}

private extension GameOhterSettingView {
    var gameCategoryView: some View {
        OInputField(
            title: "대국 카테고리",
            value: selectedCategoryString,
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
