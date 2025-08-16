//
//  CrossLineModifier.swift
//  MyGame
//
//  Created by 김동준 on 12/14/24
//

import SwiftUI

struct CrossLineModifier: ViewModifier {
    let hasData: Bool
    let circleSize: CGFloat
    
    init(
        hasData: Bool,
        circleSize: CGFloat
    ) {
        self.hasData = hasData
        self.circleSize = circleSize
    }
    
    func body(content: Content) -> some View {
        if hasData {
            content
                .mask(
                    Rectangle()
                    .overlay(
                        Circle()
                            .frame(width: circleSize, height: circleSize)
                            .blendMode(.destinationOut)
                    )
                    .compositingGroup()
                )
        } else {
            content
        }
    }
}
