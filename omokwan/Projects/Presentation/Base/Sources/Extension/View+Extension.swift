//
//  View+Extension.swift
//  Base
//
//  Created by 김동준 on 11/24/24
//

import SwiftUI
import ComposableArchitecture

public extension View {
    @ViewBuilder
    func oAlert(
        _ store: StoreOf<AlertFeature>,
        content: @escaping () -> some View
    ) -> some View {
        self.modifier(
            AlertViewModifier(
                viewStore: ViewStore(store, observe: { $0 }),
                alertContent: content
            )
        )
    }
}

public extension View {
    func swipeBackDisabled(_ disabled: Bool) -> some View {
        modifier(SwipeBackDisabledModifier(disabled: disabled))
    }
}
