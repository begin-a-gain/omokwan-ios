//
//  DynamicSheetModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 9/15/25
//

import SwiftUI

public struct DynamicSheetModifier: ViewModifier {
    @State private var contentHeight: CGFloat = 0
    
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewHeightKey.self, value: geometry.size.height)
                }
            )
            .onPreferenceChange(ViewHeightKey.self) { height in
                contentHeight = height
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([
                .height(contentHeight)
            ])
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
