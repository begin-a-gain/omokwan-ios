//
//  MainUtil.swift
//  Main
//
//  Created by 김동준 on 7/24/25
//

public struct MainUtil {
    static public func getBottomTabBarHeight(_ hasBottomSafeArea: Bool) -> Double {
        return hasBottomSafeArea
            ? MainConstants.bottomTabBarHeightWithSafeArea
            : MainConstants.bottomTabBarHeightWithoutSafeArea
    }
}
