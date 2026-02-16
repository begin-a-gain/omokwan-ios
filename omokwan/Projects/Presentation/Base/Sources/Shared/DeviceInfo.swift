//
//  DeviceInfo.swift
//  Base
//
//  Created by jumy on 2/16/26.
//

import Foundation

public class DeviceInfo {
    public static let shared = DeviceInfo()
    private init() {}

    public let bottomTabBarHeightWithSafeArea: CGFloat = 100
    public let bottomTabBarHeightWithoutSafeArea: CGFloat = 80

    private var bottomSafeArea: CGFloat = 0
    public var hasHomeIndicator: Bool { bottomSafeArea > 0 }
    
    public var bottomTabBarHeight: CGFloat {
        hasHomeIndicator
        ? bottomTabBarHeightWithSafeArea
        : bottomTabBarHeightWithoutSafeArea
    }
    
    public var homeIndicatorHeight: CGFloat {
        hasHomeIndicator ? 20 : 0
    }
    
    public func update(bottom: CGFloat) {
        bottomSafeArea = bottom
    }
}
