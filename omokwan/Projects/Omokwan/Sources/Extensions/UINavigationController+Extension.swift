//
//  UINavigationController+Extension.swift
//  App
//
//  Created by 김동준 on 1/4/25
//

import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count > 1 else { return false }
        return topViewController?.isSwipeBackDisabled != true
    }
}
