//
//  UIViewController+Extension.swift
//  Omokwan
//
//  Created by jumy on 3/27/26.
//

import UIKit
import ObjectiveC

private var swipeBackDisabledKey: UInt8 = 0

public extension UIViewController {
    var isSwipeBackDisabled: Bool {
        get {
            (objc_getAssociatedObject(self, &swipeBackDisabledKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &swipeBackDisabledKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
