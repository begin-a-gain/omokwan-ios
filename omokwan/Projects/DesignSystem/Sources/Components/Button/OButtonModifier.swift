//
//  OButtonModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 11/10/24
//

import SwiftUI

struct OButtonModifier: ViewModifier {
    let type: OButtonType
    let status: OButtonStatus
    let needCornerRadius: Bool
    
    init(
        type: OButtonType,
        status: OButtonStatus,
        needCornerRadius: Bool
    ) {
        self.type = type
        self.status = status
        self.needCornerRadius = needCornerRadius
    }
    
    func body(content: Content) -> some View {
        if needCornerRadius {
            switch type {
            case .default, .text:
                content
                    .cornerRadius(8)
            case .outline:
                content
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(strokeColor, lineWidth: 1.0))
            }
        } else {
            content
        }
    }
    
    private var strokeColor: Color {
        switch status {
        case .default:
            OColors.strokePrimary.swiftUIColor
        case .error:
            OColors.strokeAlert.swiftUIColor
        case .disable:
            OColors.strokeDisable.swiftUIColor
        }
    }
}
