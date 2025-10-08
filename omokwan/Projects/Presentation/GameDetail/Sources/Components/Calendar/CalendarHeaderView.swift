//
//  CalendarHeaderView.swift
//  GameDetail
//
//  Created by 김동준 on 10/5/25
//

import SwiftUI
import DesignSystem

struct CalendarHeaderView: View {
    private let headerString: String
    
    init(headerString: String) {
        self.headerString = headerString
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            OText(
                formatYearMonth(headerString),
                token: .title_02,
                color: OColors.text01.swiftUIColor
            )
            .greedyWidth()
            .vPadding(8)
            .background(OColors.ui02.swiftUIColor)
            
            Rectangle()
                .height(2)
                .greedyWidth()
                .foregroundStyle(OColors.stroke02.swiftUIColor)
        }
        .cornerRadius(8, corners: [.topLeft, .topRight])
        .hPadding(20)
    }
    
    private func formatYearMonth(_ input: String) -> String {
        let parts = input.split(separator: "-")
        guard parts.count == 2,
              let year = parts.first,
              let month = parts.last else {
            return input
        }
        return "\(year). \(month)월"
    }
}
