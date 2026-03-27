//
//  SwipeBackViewModifier.swift
//  Base
//
//  Created by jumy on 3/27/26.
//

import SwiftUI

struct SwipeBackDisabledModifier: ViewModifier {
    let disabled: Bool

    func body(content: Content) -> some View {
        content
            .background(
                SwipeBackConfigurator(disabled: disabled)
                    .frame(width: 0, height: 0)
            )
    }
}

private struct SwipeBackConfigurator: UIViewControllerRepresentable {
    let disabled: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.parent?.isSwipeBackDisabled = disabled
            uiViewController.navigationController?.topViewController?.isSwipeBackDisabled = disabled
        }
    }
}
