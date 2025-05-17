//
//  View+Extension.swift
//  DesignSystem
//
//  Created by 김동준 on 10/1/24
//

import SwiftUI

public extension View {
    func greedyWidth(_ alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func greedyHeight(_ alignment: Alignment = .center) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func greedyFrame(_ alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    func hPadding(_ horizontalPadding: CGFloat) -> some View {
        padding(.horizontal, horizontalPadding)
    }
    
    func vPadding(_ verticalPadding: CGFloat) -> some View {
        padding(.vertical, verticalPadding)
    }
    
    func frame(_ width: CGFloat, _ height: CGFloat, _ alignment: Alignment = .center) -> some View {
        frame(width: width, height: height, alignment: alignment)
    }
    
    func width(_ width: CGFloat, _ alignment: Alignment = .center) -> some View {
        frame(width: width, alignment: alignment)
    }
    
    func height(_ height: CGFloat, _ alignment: Alignment = .center) -> some View {
        frame(height: height, alignment: alignment)
    }
}

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// About Toast
public extension View {
    func oToast(
        isPresented: Binding<Bool>,
        message: String,
        bottomPadding: CGFloat = 24,
        backgroundColor: Color = OColors.uiBackground2.swiftUIColor,
        textColor: Color = OColors.textOn01.swiftUIColor,
        dismissDuration: TimeInterval = 3.0
    ) -> some View {
        self.modifier(
            OToastViewModifier(
                isPresented: isPresented,
                message: message,
                bottomPadding: bottomPadding,
                backgroundColor: backgroundColor,
                textColor: textColor,
                dismissDuration: dismissDuration
            )
        )
    }
}
