//
//  UserStatusCrossLineView.swift
//  GameDetail
//
//  Created by 김동준 on 9/29/25
//

import SwiftUI
import DesignSystem
import Domain

struct UserStatusCrossLineView: View {
    private let userStatus: GameDetailUserStatus?
    private let me: Bool
    private let size: CGFloat
    private let isToday: Bool
    
    init(
        userStatus: GameDetailUserStatus?,
        me: Bool,
        size: CGFloat,
        isToday: Bool
    ) {
        self.userStatus = userStatus
        self.me = me
        self.size = size
        self.isToday = isToday
    }
    
    var body: some View {
        CrossLineView(
            crossLineSize: size,
            circleSize: circleSize,
            strokeColor: me
                ? OColors.strokePrimaryOpa40.swiftUIColor
                : OColors.stroke02.swiftUIColor,
            hasData: hasData
        )
    }
}

private extension UserStatusCrossLineView {
    var circleSize: CGFloat? {
        shouldShowCircle ? size - 10 : nil
    }
    
    var hasData: Bool {
        shouldShowCircle
    }
    
    var shouldShowCircle: Bool {
        (isToday && me) || (userStatus?.isCompleted == true)
    }
}
