//
//  StrokeDivider.swift
//  DesignSystem
//
//  Created by 김동준 on 12/3/24
//

import SwiftUI

public struct StrokeDivider: View {
    let color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public var body: some View {
        Spacer()
            .height(1)
            .greedyWidth()
            .background(color)
    }
}
