//
//  DetailComboSheetView.swift
//  GameDetail
//
//  Created by jumy on 3/19/26.
//

import DesignSystem
import SwiftUI

struct DetailComboSheetView: View {
    @Environment(\.dismiss) private var dismiss

    let comboCount: Int
    
    init(comboCount: Int) {
        self.comboCount = comboCount
    }
    
    var body: some View {
        VStack(spacing: 0) {
            textSection
                .hPadding(20)
                .padding(.top, 64)
            
            Spacer()
            OImages.imgCombo.swiftUIImage
            
            Spacer()
            sheetButton
        }
        .background(OColors.uiBackground.swiftUIColor)
    }
    
    private var textSection: some View {
        VStack(spacing: 12) {
            OText(
                "오목 달성!",
                token: .display_02
            )

            HStack(spacing: 4) {
                OText(
                    "\(comboCount)번 연속 콤보 달성 중",
                    token: .subtitle_02,
                    color: OColors.textPrimary.swiftUIColor
                )
            }
            .vPadding(8)
            .hPadding(12)
            .background(OColors.oPrimary.swiftUIColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(OColors.strokePrimary.swiftUIColor, lineWidth: 1.0)
            )
        }
    }
    
    private var sheetButton: some View {
        OButton(
            title: "확인",
            status: .default,
            type: .default,
            action: { dismiss() }
        )
        .vPadding(16)
        .hPadding(20)
    }
}
