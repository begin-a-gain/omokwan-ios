//
//  DynamicWidthChipsModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 1/30/25
//

import SwiftUI

struct DynamicWidthChipsModifier: ViewModifier {
    private var width: CGFloat = 0
    @Binding private var chipWidths: [String: CGFloat]
    private var title: String
    
    init(
        chipWidths: Binding<[String: CGFloat]>,
        title: String
    ) {
        self._chipWidths = chipWidths
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.onAppear {
                        let isContained = chipWidths.contains(where: {
                            $0.key == title
                        })
                        if !isContained {
                            chipWidths[title] = geometry.size.width
                        }
                    }
                }
            )
    }
}
