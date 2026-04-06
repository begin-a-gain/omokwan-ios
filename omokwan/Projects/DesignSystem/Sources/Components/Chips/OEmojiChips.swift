//
//  OEmojiChips.swift
//  DesignSystem
//
//  Created by 김동준 on 11/30/24
//

import SwiftUI

public struct OEmojiChips: View {
    let emoji: String
    let title: String
    @Binding var isSelected: Bool
    
    public init(
        emoji: String,
        title: String,
        isSelected: Binding<Bool>
    ) {
        self.emoji = emoji
        self.title = title
        self._isSelected = isSelected
    }
    
    public var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            HStack(spacing: 4) {
                OText(
                    emoji,
                    token: .subtitle_02
                )
                OText(
                    title,
                    token: .subtitle_02,
                    color: isSelected ? OColors.textPrimary.swiftUIColor : OColors.text01.swiftUIColor
                )
            }
            .vPadding(8)
            .hPadding(12)
            .background(isSelected ? OColors.oPrimary.swiftUIColor.opacity(0.1) : OColors.uiBackground.swiftUIColor)
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
}
