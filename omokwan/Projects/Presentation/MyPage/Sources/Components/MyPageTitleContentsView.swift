//
//  MyPageTitleContentsView.swift
//  MyPage
//
//  Created by 김동준 on 11/2/25
//

import SwiftUI
import DesignSystem

struct MyPageTitleContentsView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            OText(
                title,
                token: .title_02
            )
            .greedyWidth(.leading)
            .hPadding(16)
            .padding(.top, 20)
            .padding(.bottom, 12)
            
            content
        }
        .background(OColors.uiBackground.swiftUIColor)
        .cornerRadius(8)
    }
}
