//
//  OmokStoneType.swift
//  DesignSystem
//
//  Created by 김동준 on 8/16/25
//

import SwiftUI

public enum OmokStoneType {
    case primary
    case white
    case black
    
    var gradientColors: [Color] {
        switch self {
        case .primary:
            [OColors.oWhite.swiftUIColor, OColors.uiPrimary.swiftUIColor, OColors.uiLinearGradientEndPoint.swiftUIColor]
        case .black:
            [OColors.oWhite.swiftUIColor, OColors.oBlack.swiftUIColor, OColors.stoneBlackLinearLast.swiftUIColor]
        case .white:
            [OColors.oWhite.swiftUIColor, OColors.gray600.swiftUIColor, OColors.oWhite.swiftUIColor]
        }
    }
    
    var gradientStops: [Gradient.Stop] {
        zip(
            gradientColors, [
                DesignConstants.linearGradientStartPoint,
                DesignConstants.linearGradientMiddlePoint,
                DesignConstants.linearGradientEndPoint
            ]
        )
        .map { Gradient.Stop(color: $0, location: $1) }
    }
    
    var opacity: Double {
        switch self {
        case .primary, .black: return 0.5
        case .white: return 0.2
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .primary:
            OColors.uiPrimary.swiftUIColor
        case .black, .white:
            OColors.oBlack.swiftUIColor
        }
    }
}
