//
//  OTextFieldModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 10/25/24
//

import SwiftUI

struct OTextFieldModifier: ViewModifier {
    let type: OTextFieldType
    
    init(type: OTextFieldType) {
        self.type = type
    }
    
    func body(content: Content) -> some View {
        switch type {
        case .readOnly, .disable:
            content
        default:
            content
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(strokeColor, lineWidth: 1.0))
        }
    }
    
    private var strokeColor: Color {
        switch type {
        case .default, .filled:
            OColors.stroke02.swiftUIColor
        case .focus:
            OColors.strokeFocus.swiftUIColor
        case .error:
            OColors.strokeAlert.swiftUIColor
        case .readOnly, .disable:
            .clear
        }
    }
}
