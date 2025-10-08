//
//  OmokStone.swift
//  DesignSystem
//
//  Created by 김동준 on 8/13/25
//

import SwiftUI

public struct OmokStone: View {
    let stoneSize: CGFloat
    let stoneType: OmokStoneType
    let shadowRadius: CGFloat
    
    public init(
        stoneSize: CGFloat,
        stoneType: OmokStoneType,
        shadowRadius: CGFloat = 10
    ) {
        self.stoneSize = stoneSize
        self.stoneType = stoneType
        self.shadowRadius = shadowRadius
    }
    
    public var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    stops: stoneType.gradientStops,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(stoneType.opacity)
            .frame(width: stoneSize, height: stoneSize)
            .shadow(
                color: stoneType.shadowColor,
                radius: shadowRadius,
                x: 0, y: 0
            )
            .modifier(OmokStoneModifier(stoneType: stoneType))
    }
}
