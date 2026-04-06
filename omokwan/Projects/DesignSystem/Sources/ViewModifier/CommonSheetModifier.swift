//
//  CommonSheetModifier.swift
//  DesignSystem
//
//  Created by 김동준 on 11/24/24
//

import SwiftUI

public struct CommonSheetModifier: ViewModifier {
    private let detent: Set<PresentationDetent>
    
    public init(detent: Set<PresentationDetent>) {
        self.detent = detent
    }
    
    public func body(content: Content) -> some View {
        content
            .presentationDragIndicator(.visible)
            .presentationDetents(detent)
    }
}
