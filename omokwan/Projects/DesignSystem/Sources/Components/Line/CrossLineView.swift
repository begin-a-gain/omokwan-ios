//
//  CrossLineView.swift
//  MyGame
//
//  Created by 김동준 on 12/7/24
//

import SwiftUI

public struct CrossLineView: View {
    let crossLineSize: CGFloat
    let circleSize: CGFloat?
    let strokeColor: Color
    let hasData: Bool
    
    public init(
        crossLineSize: CGFloat,
        circleSize: CGFloat? = nil,
        strokeColor: Color,
        hasData: Bool
    ) {
        self.crossLineSize = crossLineSize
        self.circleSize = circleSize
        self.strokeColor = strokeColor
        self.hasData = hasData
    }
    
    public var body: some View {
        CrossLinePathView()
            .stroke(strokeColor, lineWidth: 2)
            .frame(width: crossLineSize, height: crossLineSize)
            .modifier(
                CrossLineModifier(
                    hasData: hasData,
                    circleSize: circleSize
                )
            )
    }
}

private struct CrossLinePathView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // .horizontal
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        // .vertical
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        return path
    }
}
