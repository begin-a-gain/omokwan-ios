//
//  MainUtil.swift
//  Main
//
//  Created by 김동준 on 7/24/25
//

struct MainUtil {
    static func getBottomTabBarHeight(_ hasBottomSafeArea: Bool) -> Double {
        return hasBottomSafeArea
            ? MainConstants.bottomTabBarHeightWithSafeArea
            : MainConstants.bottomTabBarHeightWithoutSafeArea
    }
}
