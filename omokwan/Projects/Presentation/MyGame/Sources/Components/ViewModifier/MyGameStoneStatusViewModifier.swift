//
//  MyGameStoneStatusViewModifier.swift
//  MyGame
//
//  Created by 김동준 on 12/11/24
//

import SwiftUI
import DesignSystem
import Domain

struct MyGameStoneStatusViewModifier: ViewModifier {
    let myGameCompleteStatus: MyGameCompleteStatus
    let size: CGFloat
    
    init(
        myGameCompleteStatus: MyGameCompleteStatus,
        size: CGFloat
    ) {
        self.myGameCompleteStatus = myGameCompleteStatus
        self.size = size
    }
    
    func body(content: Content) -> some View {
        switch myGameCompleteStatus {
        case .complete, .inCompleteWithSkip:
            content
        case .inComplete:
            ZStack {
                content
                Circle()
                    .stroke(OColors.strokeDisable.swiftUIColor, style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .padding(.trailing, 4)
                    .padding(.top, 4)
                    .frame(size, size)
            }
        }
    }
}
