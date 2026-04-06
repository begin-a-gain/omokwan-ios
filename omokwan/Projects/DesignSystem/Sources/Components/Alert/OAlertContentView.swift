//
//  OAlertContentView.swift
//  DesignSystem
//
//  Created by 김동준 on 12/22/24
//

import SwiftUI

public struct OAlertContentView<Content: View>: View {
    let type: OAlertType
    let primaryButtonAction: () -> Void
    let secondaryButtonAction: (() -> Void)?
    let content: () -> Content
    
    public init(
        type: OAlertType,
        primaryButtonAction: @escaping () -> Void,
        secondaryButtonAction: (() -> Void)? = nil,
        content: @escaping () -> Content
    ) {
        self.type = type
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            content().padding(20)
            switch type {
            case .defaultOnlyOK:
                Button {
                    primaryButtonAction()
                } label: {
                    OText(
                        "확인",
                        token: .title_02,
                        color: OColors.textOn01.swiftUIColor
                    )
                    .vPadding(16)
                    .greedyWidth()
                    .background(OColors.uiPrimary.swiftUIColor)
                }
            default:
                HStack(spacing: 0) {
                    Button {
                        primaryButtonAction()
                    } label: {
                        OText(
                            "취소",
                            token: .title_02,
                            color: OColors.textOnDisable.swiftUIColor
                        )
                        .vPadding(16)
                        .greedyWidth()
                        .background(OColors.uiDisable01.swiftUIColor)
                    }
                    Button {
                        if let action = secondaryButtonAction {
                            action()
                        }
                    } label: {
                        OText(
                            "확인",
                            token: .title_02,
                            color: OColors.textOn01.swiftUIColor
                        )
                        .vPadding(16)
                        .greedyWidth()
                        .background(okbuttonBackgroundColor)
                    }
                }
            }
        }
        .cornerRadius(12)
        .background(
            OColors.uiBackground.swiftUIColor
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .hPadding(20)
    }
    
    private var okbuttonBackgroundColor: Color {
        switch type {
        case .defaultWithOpacity, .onlyTextWithOpacity:
            OColors.uiPrimary.swiftUIColor.opacity(0.5)
        default:
            OColors.uiPrimary.swiftUIColor
        }
    }
}
