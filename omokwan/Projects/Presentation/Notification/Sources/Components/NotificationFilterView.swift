//
//  NotificationFilterView.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import SwiftUI
import DesignSystem

struct NotificationFilterView: View {
    private let title: String
    private let count: Int
    private let isSelected: Bool
    private let action: () -> Void
    
    init(
        title: String,
        count: Int = 0,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.count = count
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
                    color: textColor
                )
                
                if count > 0 {
                    OText(
                        "\(count)",
                        token: .subtitle_02,
                        color: OColors.textPrimary.swiftUIColor
                    )
                }
            }
            .vPadding(8)
            .hPadding(12)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(strokeColor, lineWidth: 1.0)
            )
        }
    }
}

private extension NotificationFilterView {
    var backgroundColor: Color {
        isSelected
            ? OColors.oPrimary.swiftUIColor.opacity(0.1)
            : OColors.uiBackground.swiftUIColor
    }
    
    var strokeColor: Color {
        isSelected
            ? OColors.strokePrimary.swiftUIColor
            : OColors.stroke01.swiftUIColor
    }
    
    var textColor: Color {
        isSelected
            ? OColors.textPrimary.swiftUIColor
            : OColors.text01.swiftUIColor
    }
}
