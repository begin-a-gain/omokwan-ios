//
//  SelectedUserInfoRowView.swift
//  GameDetail
//
//  Created by jumy on 3/17/26.
//

import SwiftUI
import DesignSystem
import Domain

struct SelectedUserInfoRowView: View {
    private let userInfoList: [GameUserInfo]
    private let action: (GameUserInfo) -> Void
    
    init(
        userInfoList: [GameUserInfo],
        action: @escaping (GameUserInfo) -> Void
    ) {
        self.userInfoList = userInfoList
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<userInfoList.count, id: \.self) { index in
                normalUserView(userInfoList[index])
            }
        }
        .greedyWidth(.leading)
        .hPadding(20)
    }
    
    private func normalUserView(_ userInfo: GameUserInfo) -> some View {
        Button {
            action(userInfo)
        } label: {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 4) {
                    Circle()
                        .fill(OColors.ui03.swiftUIColor)
                        .frame(width: 48, height: 48)
                        .overlay {
                            OText(
                                String(userInfo.nickname.prefix(1)),
                                token: .display
                            )
                        }
                    
                    OText(
                        userInfo.nickname,
                        token: .subtitle_01
                    )
                    .frame(width: 58)
                }
                .vPadding(8)
                
                cancelCircle
            }
        }
    }
    
    private var cancelCircle: some View {
        ZStack {
            Circle()
                .fill(OColors.uiBackground2.swiftUIColor)
                .frame(20, 20)
            
            OImages.icCancel.swiftUIImage
                .renderingMode(.template)
                .resizable()
                .frame(16, 16)
                .foregroundStyle(OColors.iconOn01.swiftUIColor)
        }
    }
}
