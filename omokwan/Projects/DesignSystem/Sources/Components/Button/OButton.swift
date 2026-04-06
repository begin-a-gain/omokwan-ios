//
//  OButton.swift
//  DesignSystem
//
//  Created by 김동준 on 10/4/24
//

import SwiftUI

public struct OButton: View {
    let title: String
    let status: OButtonStatus
    let type: OButtonType
    let size: OButtonSize
    let needCornerRadius: Bool
    let leadingImage: Image?
    let trailingImage: Image?
    let action: (() -> Void)?
    var viewSpacing: Double {
        size == .big ? 12 : 10
    }
    var imageSize: Double {
        size == .big ? 20 : 16
    }
    var vPaddingSize: Double {
        size == .big ? 14 : 10
    }
    
    public init(
        title: String,
        status: OButtonStatus,
        type: OButtonType,
        size: OButtonSize = .big,
        needCornerRadius: Bool = true,
        leadingImage: Image? = nil,
        trailingImage: Image? = nil,
        action: (()-> Void)? = nil
    ) {
        self.title = title
        self.status = status
        self.type = type
        self.size = size
        self.needCornerRadius = needCornerRadius
        self.leadingImage = leadingImage
        self.trailingImage = trailingImage
        self.action = action
    }
    
    public var body: some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            HStack(spacing: 0) {
                if let leadingImage = leadingImage {
                    HStack(spacing: 0) {
                        leadingImage
                            .renderingMode(.template)
                            .resizedToFit(imageSize, imageSize)
                            .foregroundColor(textColor)
                        Spacer().width(viewSpacing)
                    }
                }
                OText(
                    title,
                    token: size == .big ? .title_02 : .subtitle_02,
                    color: textColor
                )
                .vPadding(vPaddingSize)
                if let trailingImage = trailingImage {
                    HStack(spacing: 0) {
                        Spacer().width(viewSpacing)
                        trailingImage
                            .renderingMode(.template)
                            .resizedToFit(imageSize, imageSize)
                            .foregroundColor(textColor)
                    }
                }
            }
            .greedyWidth()
            .disabled(status == .disable)
            .background(backgroundColor)
            .modifier(OButtonModifier(type: type, status: status, needCornerRadius: needCornerRadius))
            .cornerRadius(needCornerRadius ? 8 : 0)
        }.disabled(status == .disable)
    }
    
    private var textColor: Color {
        switch status {
        case .default:
            type == .default
                ? OColors.textOn01.swiftUIColor
                : OColors.textPrimary.swiftUIColor
        case .error:
            type == .default
                ? OColors.textOn01.swiftUIColor
                : OColors.textAlert.swiftUIColor
        case .disable:
            type == .default
                ? OColors.textOnDisable.swiftUIColor
                : OColors.textDisable.swiftUIColor
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .default:
            switch status {
            case .default:
                OColors.uiPrimary.swiftUIColor
            case .error:
                OColors.uiAlert.swiftUIColor
            case .disable:
                OColors.uiDisable01.swiftUIColor
            }
        default:
            Color.clear
        }
    }
}

public enum OButtonStatus {
    case `default`
    case error
    case disable
}

public enum OButtonType {
    case `default`
    case outline
    case text
}

public enum OButtonSize {
    case big
    case small
}
