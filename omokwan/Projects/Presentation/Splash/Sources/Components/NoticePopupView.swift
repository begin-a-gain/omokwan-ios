//
//  NoticePopupView.swift
//  Splash
//
//  Created by jumy on 3/21/26.
//

import DesignSystem
import SwiftUI
import Domain

struct NoticePopupView: View {
    private let info: NoticePopupInfo
    private let action: (() -> Void)
    
    init(info: NoticePopupInfo, action: @escaping () -> Void) {
        self.info = info
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            alertContents
                .padding(20)
            
            OButton(
                title: "확인",
                status: isButtonDisabled ? .disable : .default,
                type: .default,
                needCornerRadius: false
            ) {
                action()
            }
        }
        .cornerRadius(12)
        .background(
            OColors.uiBackground.swiftUIColor
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .hPadding(20)
    }
}

private extension NoticePopupView {
    var alertContents: some View {
        VStack(spacing: 8) {
            OText(
                title,
                token: .headline
            )
            .greedyWidth()
            OText(
                contents,
                token: .body_long_02,
                lineLimit: nil
            )
            .greedyWidth()
        }
        .vPadding(4)
    }
}

private extension NoticePopupView {
    var title: String {
        info.title ?? "-"
    }
    
    var contents: String {
        info.contents ?? "-"
    }
    
    var isButtonDisabled: Bool {
        let isSkipPossible = info.skipPossible ?? false
        return !isSkipPossible
    }
}
