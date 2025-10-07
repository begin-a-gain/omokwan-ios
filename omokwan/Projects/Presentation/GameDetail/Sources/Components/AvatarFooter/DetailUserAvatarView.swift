//
//  DetailUserAvatarView.swift
//  GameDetail
//
//  Created by 김동준 on 9/15/25
//

import SwiftUI
import DesignSystem
import Domain

struct DetailUserAvatarView: View {
    private let availableWidth: CGFloat
    private let hPadding: CGFloat
    private let stoneRowWidth: CGFloat
    private let itemSize: CGFloat
    private let avatarSize: CGFloat
    private let userInfos: [GameUserInfo?]
    private let action: (Int?) -> Void
    private let textWidth: CGFloat
    
    init(
        availableWidth: CGFloat,
        hPadding: CGFloat,
        userInfos: [GameUserInfo?],
        action: @escaping (Int?) -> Void
    ) {
        self.availableWidth = availableWidth
        self.hPadding = hPadding
        self.stoneRowWidth = GameDetailConstants.stoneRowWidthRatio * availableWidth
        self.itemSize = stoneRowWidth / 5
        self.avatarSize = itemSize - 10
        self.userInfos = userInfos
        self.action = action
        self.textWidth = GameDetailConstants.calendarDayTextWidthRatio * availableWidth
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<userInfos.count, id: \.self) { index in
                if let userInfo = userInfos[index] {
                    normalUserView(userInfo, index)
                } else {
                    emptyUserView
                }
            }
        }
        .greedyWidth(.leading)
        .padding(.leading, textWidth)
        .hPadding(hPadding)
    }
    
    private func normalUserView(_ userInfo: GameUserInfo, _ index: Int) -> some View {
        Button {
            action(userInfo.userID)
        } label: {
            VStack(spacing: 0) {
                Circle()
                    .fill(circleFillColor(index))
                    .frame(width: avatarSize, height: avatarSize)
                    .overlay {
                        OText(
                            String(userInfo.nickname.prefix(1)),
                            token: .display,
                            color: circleTextColor(index)
                        )
                    }
                
                OText(
                    userInfo.nickname,
                    token: .subtitle_01,
                    color: nicknameTextColor(index)
                )
                .frame(width: avatarSize)
            }
            .frame(width: itemSize, height: itemSize)
            .vPadding(8)
        }
    }
    
    private var emptyUserView: some View {
        Button {
            action(nil)
        } label: {
            VStack(spacing: 0) {
                Circle()
                    .stroke(OColors.strokeDisable.swiftUIColor, style: StrokeStyle(lineWidth: 2, dash: [3, 3]))
                    .frame(width: avatarSize, height: avatarSize)
                    .overlay {
                        OImages.icPlus.swiftUIImage
                            .renderingMode(.template)
                            .resizedToFit(24, 24)
                            .foregroundColor(OColors.strokeDisable.swiftUIColor)
                    }
                
                OText(
                    "멤버 추가",
                    token: .subtitle_01,
                    color: OColors.textDisable.swiftUIColor
                )
                .frame(width: avatarSize)
            }
            .frame(width: itemSize, height: itemSize)
            .vPadding(8)
        }
    }
}

private extension DetailUserAvatarView {
    func circleFillColor(_ index: Int) -> Color {
        if index == 0 {
            OColors.oPrimary.swiftUIColor
        } else {
            OColors.ui03.swiftUIColor
        }
    }
    
    func circleTextColor(_ index: Int) -> Color {
        if index == 0 {
            OColors.oWhite.swiftUIColor
        } else {
            OColors.text01.swiftUIColor
        }
    }
    
    func nicknameTextColor(_ index: Int) -> Color {
        if index == 0 {
            OColors.oPrimary.swiftUIColor
        } else {
            OColors.text01.swiftUIColor
        }
    }
}
