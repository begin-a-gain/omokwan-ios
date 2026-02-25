//
//  ONavigationBar.swift
//  DesignSystem
//
//  Created by 김동준 on 10/4/24
//

import SwiftUI

public struct ONavigationBar: View {
    let title: String?
    let isMain: Bool
    let isSkip: Bool
    let leadingIcon: Image?
    let leadingIconAction: (() -> Void)?
    let trailingIcon: Image?
    let trailingIconAction: (() -> Void)?
    let trailingAdditionalIcon: Image?
    let trailingAdditionalIconAction: (() -> Void)?
 
    public init(
        title: String? = nil,
        isMain: Bool = false,
        isSkip: Bool = false,
        leadingIcon: Image? = nil,
        leadingIconAction: (() -> Void)? = nil,
        trailingIcon: Image? = nil,
        trailingIconAction: (() -> Void)? = nil,
        trailingAdditionalIcon: Image? = nil,
        trailingAdditionalIconAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.isMain = isMain
        self.isSkip = isSkip
        self.leadingIcon = leadingIcon
        self.leadingIconAction = leadingIconAction
        self.trailingIcon = trailingIcon
        self.trailingIconAction = trailingIconAction
        self.trailingAdditionalIcon = trailingAdditionalIcon
        self.trailingAdditionalIconAction = trailingAdditionalIconAction
    }
    
    public var body: some View {
        ZStack {
            if let title = title {
                OText(
                    title,
                    token: .headline,
                    color: OColors.text01.swiftUIColor
                )
                .vPadding(14)
                .greedyWidth()
                .hPadding(60)
            }
            
            HStack(spacing: 0) {
                if isMain {
                    mainLogoView
                } else {
                    if let leadingIcon = leadingIcon {
                        leadingIconView(leadingIcon)
                    }
                }
                if isSkip {
                    skipButton
                } else {
                    HStack(spacing: 0) {
                        Spacer()
                        if let trailingAdditionalIcon = trailingAdditionalIcon {
                            trailingAdditionalIconView(trailingAdditionalIcon)
                        }
                        if let trailingIcon = trailingIcon {
                            trailingIconView(trailingIcon)
                        }
                    }
                }
            }
        }
        .greedyWidth()
        .background(OColors.uiBackground.swiftUIColor)
        .navigationBarBackButtonHidden(true)
    }
    
    private var mainLogoView: some View {
        HStack(spacing: 0) {
            OImages.imgOmokwanLogo.swiftUIImage
                .padding(.leading, 20)
                .vPadding(8)
            Spacer()
        }
    }
    
    private func leadingIconView(_ image: Image) -> some View {
        HStack(spacing: 0) {
            Button {
                if let action = leadingIconAction {
                    action()
                }
            } label: {
                image.resizedToFit(24,24).vPadding(16).hPadding(20)
            }
            Spacer()
        }
    }
    
    private func trailingAdditionalIconView(_ image: Image) -> some View {
        HStack(spacing: 0) {
            Button {
                if let action = leadingIconAction {
                    action()
                }
            } label: {
                image.resizedToFit(24,24).padding(12)
            }
        }
    }
    
    private func trailingIconView(_ image: Image) -> some View {
        HStack(spacing: 0) {
            Button {
                if let action = trailingIconAction {
                    action()
                }
            } label: {
                image.resizedToFit(24,24)
                    .vPadding(trailingAdditionalIcon == nil ? 16 : 12)
                    .padding(.leading, trailingAdditionalIcon == nil ? 16 : 12)
                    .padding(.trailing, trailingAdditionalIcon == nil ? 20 : 12)
            }
        }
    }
    
    private var skipButton: some View {
        HStack(spacing: 0) {
            Spacer()
            Button {
                if let trailingIconAction = trailingIconAction {
                    trailingIconAction()
                }
            } label: {
                OText(
                    "건너뛰기",
                    token: .body_02,
                    color: OColors.text02.swiftUIColor
                )
                .vPadding(18)
                .hPadding(20)
            }
        }
    }
}
