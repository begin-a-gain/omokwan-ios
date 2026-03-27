//
//  GameManagementSettingView.swift
//  GameDetail
//
//  Created by 김동준 on 9/21/25
//

import SwiftUI
import DesignSystem

struct GameManagementSettingView: View {
    private let isHost: Bool
    private let allUserCount: Int
    private let inviteButtonAction: () -> Void
    private let hostChangeButtonAction: (() -> Void)?
    private let isHostChangeVisible: Bool
    
    init(
        isHost: Bool,
        allUserCount: Int,
        inviteButtonAction: @escaping () -> Void,
        hostChangeButtonAction: (() -> Void)? = nil
    ) {
        self.isHost = isHost
        self.allUserCount = allUserCount
        self.inviteButtonAction = inviteButtonAction
        self.hostChangeButtonAction = hostChangeButtonAction
        self.isHostChangeVisible = allUserCount > 1 && isHost
    }
    
    var body: some View {
        VStack(spacing: 6) {
            OText(
                "대국 관리",
                token: .subtitle_02
            )
            .hPadding(16)
            .greedyWidth(.leading)
            VStack(spacing: 0) {
                inviteView
                
                if isHostChangeVisible {
                    StrokeDivider(color: OColors.stroke02.swiftUIColor)
                    gameHostChangeView
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
}

private extension GameManagementSettingView {
    var inviteView: some View {
        OInputField(
            title: "초대하기",
            buttonAction: {
                inviteButtonAction()
            }
        )
    }
    
    var gameHostChangeView: some View {
        OInputField(
            title: "대국장 변경하기",
            buttonAction: {
                hostChangeButtonAction?()
            }
        )
    }
}
