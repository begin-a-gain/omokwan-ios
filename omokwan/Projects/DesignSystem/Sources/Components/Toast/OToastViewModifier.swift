//
//  OToastViewModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 5/17/25
//

import SwiftUI

struct OToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let bottomPadding: CGFloat
    let backgroundColor: Color
    let textColor: Color
    let dismissDuration: TimeInterval
    
    init(
        isPresented: Binding<Bool>,
        message: String,
        bottomPadding: CGFloat,
        backgroundColor: Color,
        textColor: Color,
        dismissDuration: TimeInterval
    ) {
        self._isPresented = isPresented
        self.message = message
        self.bottomPadding = bottomPadding
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.dismissDuration = dismissDuration
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    OToast(
                        message: message,
                        bottomPadding: bottomPadding,
                        backgroundColor: backgroundColor,
                        textColor: textColor
                    )
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
                    .animation(.easeInOut, value: isPresented)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + dismissDuration) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}
