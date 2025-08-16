//
//  OmokStoneModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 8/13/25
//

import SwiftUI

struct OmokStoneModifier: ViewModifier {
    let stoneType: OmokStoneType
    
    init(stoneType: OmokStoneType) {
        self.stoneType = stoneType
    }
    
    func body(content: Content) -> some View {
        switch stoneType {
        case .primary, .black:
            content
                .overlay {
                    Circle()
                        .stroke(strokeColor, lineWidth: 1)
                }
        case .white:
            content
        }
    }
    
    private var strokeColor: Color {
        switch stoneType {
        case .primary:
            OColors.strokePrimary.swiftUIColor
                .opacity(0.4)
        case .black:
            OColors.strokeDisable.swiftUIColor
        case .white:
            .clear
        }
    }
}
