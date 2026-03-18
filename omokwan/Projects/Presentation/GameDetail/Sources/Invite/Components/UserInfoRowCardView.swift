//
//  UserInfoRowCardView.swift
//  GameDetail
//
//  Created by jumy on 3/17/26.
//

import SwiftUI
import Foundation
import DesignSystem
import Domain

struct UserInfoRowCardView: View {
    private let isLoading: Bool
    private let element: GameUserInfo
    private let selectedUserInfoList: [GameUserInfo]
    private let action: (() -> Void)?
    
    init(
        isLoading: Bool = false,
        element: GameUserInfo,
        selectedUserInfoList: [GameUserInfo],
        action: (() -> Void)? = nil
    ) {
        self.isLoading = isLoading
        self.element = element
        self.selectedUserInfoList = selectedUserInfoList
        self.action = action
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            infoView
                .padding(20)
                .background(OColors.uiBackground.swiftUIColor)
        }
    }
}

private extension UserInfoRowCardView {
    var infoView: some View {
        HStack(spacing: 32) {
            infoRowSection
            
            OImages.icCheck.swiftUIImage
                .renderingMode(.template)
                .foregroundStyle(
                    selectedUserInfoList.contains(element)
                        ? OColors.strokePrimary.swiftUIColor
                        : OColors.strokeDisable.swiftUIColor
                )
                .frame(20, 20)
        }
    } 
}

private extension UserInfoRowCardView {
    var infoRowSection: some View {
        HStack(spacing: 8) {
            circleAvatarView
            
            OText(
                element.nickname,
                token: .subtitle_01
            )
            .greedyWidth(.leading)
        }
        .shimmer(isLoading, cornerRadius: 4)
    }
    var circleAvatarView: some View {
        Circle()
            .fill(OColors.ui03.swiftUIColor)
            .frame(width: 32, height: 32)
            .overlay {
                OText(
                    String(element.nickname.prefix(1)),
                    token: .title_02
                )
            }
    }
}
