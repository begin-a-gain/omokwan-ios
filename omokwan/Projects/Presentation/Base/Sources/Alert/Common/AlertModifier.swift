//
//  AlertModifier.swift
//  Base
//
//  Created by 김동준 on 11/24/24
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct AlertViewModifier<AlertContent>: ViewModifier where AlertContent: View {
    @ObservedObject private var viewStore: ViewStoreOf<AlertFeature>
    let alertContent: () -> AlertContent

    init(
        viewStore: ViewStoreOf<AlertFeature>,
        @ViewBuilder alertContent: @escaping () -> AlertContent
    ) {
        self.viewStore = viewStore
        self.alertContent = alertContent
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .allowsHitTesting(viewStore.contentAllowsHitTesting)
            
            OColors.uiBackgroundModal.swiftUIColor
                .opacity(viewStore.scrimOpacity)
                .edgesIgnoringSafeArea(.all)
            
            if viewStore.isPresented {
                alertContent()
            }
        }
    }
}
