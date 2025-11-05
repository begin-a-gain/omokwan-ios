//
//  ShimmerModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 11/4/25
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    private let isLoading: Bool
    private let cornerRadius: CGFloat
    private let baseColor: Color
    private let highlightColor: Color
    
    @State private var phase: CGFloat = 0
    
    init(
        isLoading: Bool,
        cornerRadius: CGFloat,
        baseColor: Color,
        highlightColor: Color
    ) {
        self.isLoading = isLoading
        self.cornerRadius = cornerRadius
        self.baseColor = baseColor
        self.highlightColor = highlightColor
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isLoading ? 0 : 1)
            .overlay(
                Group {
                    if isLoading {
                        shimmerView
                    }
                }
            )
    }
    
    var shimmerView: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(baseColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: linearGradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(
                            x: -geometry.size.width + (phase * geometry.size.width * 2)
                        )
                        .mask(
                            RoundedRectangle(cornerRadius: cornerRadius)
                        )
                )
        }
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                phase = 1
            }
        }
    }
    
    var linearGradientColors: [Color] {[
        baseColor,
        highlightColor,
        baseColor
    ]}
}
