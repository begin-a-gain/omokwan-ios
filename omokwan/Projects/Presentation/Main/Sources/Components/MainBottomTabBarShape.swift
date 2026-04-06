//
//  MainBottomTabBarShape.swift
//  Main
//
//  Created by 김동준 on 11/18/24
//

import SwiftUI

struct MainBottomTabBarShape: Shape {
    private let circleButtonPadding: CGFloat = MainConstants.circleButtonSize
    private let emptySpacePadding: CGFloat = 8
    private let radius: CGFloat = 8
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.minY))

        // 1번 부분
        path.addLine(
            to: CGPoint(
                x: rect.midX - ((circleButtonPadding / 2)  + emptySpacePadding) - radius,
                y: rect.minY
            )
        )

        // 2번 부분
        path.addQuadCurve(
            to: CGPoint(
                x: rect.midX - ((circleButtonPadding / 2)  + emptySpacePadding),
                y: rect.minY + radius
            ),
            control: CGPoint(
                x: rect.midX - ((circleButtonPadding / 2)  + emptySpacePadding),
                y: rect.minY
            )
        )
        
        // 3번 부분
        path.addQuadCurve(
            to: CGPoint(
                x: rect.midX,
                y: rect.minY + ((circleButtonPadding / 2)  + emptySpacePadding)
            ),
            control: CGPoint(
                x: rect.midX - ((circleButtonPadding / 2)  + emptySpacePadding) + radius,
                y: rect.minY + ((circleButtonPadding / 2)  + emptySpacePadding)
            )
        )
        
        // 4번 부분
        path.addQuadCurve(
            to: CGPoint(
                x: rect.midX + ((circleButtonPadding / 2)  + emptySpacePadding),
                y: rect.minY + 8
            ),
            control: CGPoint(
                x: rect.midX + ((circleButtonPadding / 2)  + emptySpacePadding) - radius,
                y: rect.minY + ((circleButtonPadding / 2)  + emptySpacePadding)
            )
        )
        
        // 5번 부분
        path.addQuadCurve(
            to: CGPoint(
                x: rect.midX + ((circleButtonPadding / 2)  + emptySpacePadding) + radius,
                y: rect.minY
            ),
            control: CGPoint(
                x: rect.midX + ((circleButtonPadding / 2)  + emptySpacePadding), 
                y: rect.minY
            )
        )
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.minY))
        
        path.closeSubpath()

        return path
    }
}
