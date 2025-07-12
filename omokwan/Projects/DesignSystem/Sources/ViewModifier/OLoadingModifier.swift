//
//  OLoadingModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 7/12/25
//

import SwiftUI

struct OLoadingModifier: ViewModifier {
    let isPresent: Bool
    
    init(isPresent: Bool) {
        self.isPresent = isPresent
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if (isPresent) {
                ZStack {
                    ProgressView().controlSize(.large).tint(.blue)
                }.greedyFrame().background(OColors.oBlack.swiftUIColor.opacity(0.45))
            }
        }
    }
}
