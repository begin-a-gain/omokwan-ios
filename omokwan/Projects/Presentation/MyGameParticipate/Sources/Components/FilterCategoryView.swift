//
//  FilterCategoryView.swift
//  MyGameParticipate
//
//  Created by 김동준 on 1/4/25
//

import SwiftUI
import DesignSystem

struct FilterCategoryView: View {
    let numOfCategory: Int?
    let type: MyGameParticipateFeature.State.CategoryFilterType
    let isSelected: Bool
    let action: () -> Void
    
    init(
        numOfCategory: Int? = nil,
        type: MyGameParticipateFeature.State.CategoryFilterType,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.numOfCategory = numOfCategory
        self.type = type
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                OText(
                    title,
                    token: .subtitle_02,
                    color: isSelected ? OColors.textPrimary.swiftUIColor : OColors.text01.swiftUIColor
                )
                if type == .category {
                    OImages.icArrowDown.swiftUIImage
                        .renderingMode(.template)
                        .resizedToFit(16,16)
                        .foregroundStyle(isSelected ? OColors.iconPrimary.swiftUIColor : OColors.icon01.swiftUIColor)
                }
            }
            .vPadding(8)
            .hPadding(12)
            .background(
                isSelected
                    ? OColors.oPrimary.swiftUIColor.opacity(0.1)
                    : OColors.uiBackground.swiftUIColor
            )
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(
                        isSelected ? OColors.strokePrimary.swiftUIColor : OColors.stroke01.swiftUIColor,
                        lineWidth: 1.0
                    )
            )
        }
    }
    
    private var title: String {
        switch type {
        case .availableRoom:
            return "참여 가능한 방"
        case .category:
            if let number = numOfCategory {
                return number >= 2
                    ? "카테고리 \(number)"
                    : "카테고리"
            } else {
                return "카테고리"
            }
        }
    }
}
