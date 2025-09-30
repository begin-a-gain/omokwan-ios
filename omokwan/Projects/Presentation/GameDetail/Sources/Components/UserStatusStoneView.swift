//
//  UserStatusStoneView.swift
//  GameDetail
//
//  Created by 김동준 on 9/29/25
//

import SwiftUI
import DesignSystem
import Domain

struct UserStatusStoneView: View {
    private let userStatus: GameDetailUserStatus?
    private let me: Bool
    private let itemSize: CGFloat
    private let stoneSize: CGFloat
    private let isToday: Bool
    
    init(
        userStatus: GameDetailUserStatus?,
        me: Bool,
        itemSize: CGFloat,
        isToday: Bool
    ) {
        self.userStatus = userStatus
        self.me = me
        self.itemSize = itemSize
        self.stoneSize = itemSize - 10
        self.isToday = isToday
    }
    
    var body: some View {
        Group {
            if let userStatus,
               let type = getStoneType(
                    me: me,
                    isCompleted: userStatus.isCompleted,
                    isCombo: userStatus.isCombo
               ) {
                stoneView(type: type)
            } else if isToday && me {
                emptyStoneView
            }
        }
    }
}

private extension UserStatusStoneView {
    @ViewBuilder
    func stoneView(type: OmokStoneType) -> some View {
        ZStack {
            if type == .white {
                Circle()
                    .fill(OColors.uiBackground.swiftUIColor)
                    .frame(width: stoneSize, height: stoneSize)
            }
            
            OmokStone(stoneSize: stoneSize, stoneType: type)
        }
    }
    
    func getStoneType(
        me: Bool,
        isCompleted: Bool,
        isCombo: Bool
    ) -> OmokStoneType? {
        guard isCompleted else { return nil }
        
        if isCombo {
            return me ? .primary : .black
        } else {
            return .white
        }
    }
    
    var emptyStoneView: some View {
        ZStack {
            Circle()
                .fill(OColors.oWhite.swiftUIColor)
                .frame(width: stoneSize, height: stoneSize)
            
            Circle()
                .stroke(OColors.strokePrimary.swiftUIColor, style: StrokeStyle(lineWidth: 2, dash: [3, 3]))
                .foregroundStyle(OColors.oWhite.swiftUIColor)
                .frame(width: stoneSize, height: stoneSize)
                .overlay {
                    OImages.icPlus.swiftUIImage
                        .renderingMode(.template)
                        .resizedToFit(24, 24)
                        .foregroundColor(OColors.strokePrimary.swiftUIColor)
                }
        }
        .frame(width: itemSize, height: itemSize)
    }
}
