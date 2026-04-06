//
//  RoundedTriangle.swift
//  MyGame
//
//  Created by 김동준 on 11/24/24
//

import SwiftUI

struct RoundedTriangle: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let triangleWidth: CGFloat = 30
        let triangleHeight = triangleWidth * sqrt(3) / 2
        let centerX = rect.midX
        let centerY = rect.midY
        
        let top = CGPoint(x: centerX, y: centerY - triangleHeight / 2)
        let bottomLeft = CGPoint(x: centerX - triangleWidth / 2, y: centerY + triangleHeight / 2)
        let bottomRight = CGPoint(x: centerX + triangleWidth / 2, y: centerY + triangleHeight / 2)
        
        path.move(to: top)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.closeSubpath()
        
        return path
    }
}
