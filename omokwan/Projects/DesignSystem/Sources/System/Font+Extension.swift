//
//  Font+Extension.swift
//  DesignSystem
//
//  Created by 김동준 on 9/28/24
//

import SwiftUI

public extension Font {
    enum FontToken {
        case display_02
        case display
        case headline
        case title_02
        case title_01
        case subtitle_03
        case subtitle_02
        case subtitle_01
        
        case body_02
        case body_long_02
        case body_01
        case body_long_01
        
        case caption
        case caption_long
    }
    
    static func suit(token: FontToken) -> Font {
        switch token {
        case .display_02:
            .custom(DesignSystemFontFamily.Suit.bold.name, size: 32)
        case .display:
            .custom(DesignSystemFontFamily.Suit.bold.name, size: 24)
        case .headline:
            .custom(DesignSystemFontFamily.Suit.bold.name, size: 20)
        case .title_02:
            .custom(DesignSystemFontFamily.Suit.bold.name, size: 16)
        case .title_01:
            .custom(DesignSystemFontFamily.Suit.bold.name, size: 14)
        case .subtitle_03:
            .custom(DesignSystemFontFamily.Suit.medium.name, size: 16)
        case .subtitle_02:
            .custom(DesignSystemFontFamily.Suit.medium.name, size: 14)
        case .subtitle_01:
            .custom(DesignSystemFontFamily.Suit.medium.name, size: 12)
        case .body_02:
            .custom(DesignSystemFontFamily.Suit.regular.name, size: 16)
        case .body_long_02:
            .custom(DesignSystemFontFamily.Suit.regular.name, size: 14)
        case .body_01:
            .custom(DesignSystemFontFamily.Suit.regular.name, size: 14)
        case .body_long_01:
            .custom(DesignSystemFontFamily.Suit.regular.name, size: 14)
        case .caption:
            .custom(DesignSystemFontFamily.Suit.regular.name, size: 12)
        case .caption_long:
            .custom(DesignSystemFontFamily.Suit.regular.name, size: 12)
        }
    }
}
