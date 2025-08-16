//
//  AddDottedCircleButton.swift
//  DesignSystem
//
//  Created by 김동준 on 8/16/25
//

import SwiftUI

public struct AddDottedCircleButton: View {
    let circleSize: CGFloat
    let fillColor: Color
    let primaryColor: Color
    let plusSize: CGFloat
    let action: () -> Void
    
    public init(
        circleSize: CGFloat,
        fillColor: Color,
        primaryColor: Color,
        plusSize: CGFloat = 24,
        action: @escaping () -> Void
    ) {
        self.circleSize = circleSize
        self.fillColor = fillColor
        self.primaryColor = primaryColor
        self.plusSize = plusSize
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Circle()
                .fill(fillColor)
                .overlay {
                    ZStack {
                        plusImage
                        dottedCircle
                    }
                }
                .frame(width: circleSize, height: circleSize)
        }
    }
}

private extension AddDottedCircleButton {
    var plusImage: some View {
        OImages.icPlus.swiftUIImage
            .renderingMode(.template)
            .resizedToFit(plusSize, plusSize)
            .foregroundColor(primaryColor)
    }
    
    var dottedCircle: some View {
        Circle()
            .stroke(
                primaryColor,
                style: StrokeStyle(lineWidth: 2, dash: [5, 5])
            )
    }
}
