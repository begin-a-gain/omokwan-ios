//
//  OAlert.swift
//  DesignSystem
//
//  Created by 김동준 on 11/24/24
//

import SwiftUI

public struct OAlert: View {
    let type: OAlertType
    let title: String
    let content: String
    let primaryButtonTitle: String
    let primaryButtonAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryButtonBackgroundColor: Color?
    let secondaryButtonAction: (() -> Void)?
    
    public init(
        type: OAlertType,
        title: String,
        content: String,
        primaryButtonTitle: String = "확인",
        primaryButtonAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryButtonBackgroundColor: Color? = nil,
        secondaryButtonAction: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.content = content
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonBackgroundColor = secondaryButtonBackgroundColor
        self.secondaryButtonAction = secondaryButtonAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            alertContents.padding(20)
            switch type {
            case .defaultOnlyOK:
                Button {
                    primaryButtonAction()
                } label: {
                    OText(
                        primaryButtonTitle,
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
                            secondaryButtonTitle ?? "확인",
                            token: .title_02,
                            color: OColors.textOn01.swiftUIColor
                        )
                        .vPadding(16)
                        .greedyWidth()
                        .background(secondaryButtonBackgroundColor ?? okbuttonBackgroundColor)
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
    
    @ViewBuilder
    private var alertContents: some View {
        switch type {
        case .default, .defaultOnlyOK, .defaultWithOpacity, .customButton:
            VStack(spacing: 8) {
                OText(
                    title,
                    token: .headline
                )
                .greedyWidth()
                OText(
                    content,
                    token: .body_long_02,
                    lineLimit: 2
                )
                .greedyWidth()
            }
            .vPadding(4)
        case .onlyTextDefault, .onlyTextWithOpacity:
            OText(
                title,
                token: .title_02
            )
            .greedyWidth()
            .vPadding(4)
        }
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


public enum OAlertType {
    case `default`
    case defaultWithOpacity
    case defaultOnlyOK
    case onlyTextDefault
    case onlyTextWithOpacity
    case customButton
}
