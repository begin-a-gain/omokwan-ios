//
//  OToast.swift
//  DesignSystem
//
//  Created by 김동준 on 5/17/25
//

import SwiftUI
import Foundation

struct OToast: View {
    let message: String
    let bottomPadding: CGFloat
    let backgroundColor: Color
    let textColor: Color
    
    init(
        message: String,
        bottomPadding: CGFloat,
        backgroundColor: Color,
        textColor: Color
    ) {
        self.message = message
        self.bottomPadding = bottomPadding
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    var body: some View {
        OText(
            message,
            token: .body_02,
            color: textColor,
            alignment: .leading,
            lineLimit: 2
        )
        .greedyWidth(.leading)
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(8)
        .hPadding(12)
        .padding(.bottom, bottomPadding)
    }
}
