//
//  OInputToggleField.swift
//  DesignSystem
//
//  Created by 김동준 on 12/3/24
//

import SwiftUI

public struct OInputToggleField: View {
    let title: String
    let selectAreaAction: (() -> Void)?
    let additionalInfo: String?
    @Binding var isSelected: Bool
    
    public init(
        title: String,
        selectAreaAction: (() -> Void)? = nil,
        additionalInfo: String? = nil,
        isSelected: Binding<Bool>
    ) {
        self.title = title
        self.selectAreaAction = selectAreaAction
        self.additionalInfo = additionalInfo
        self._isSelected = isSelected
    }
    
    public var body: some View {
        HStack(spacing:0) {
            Button {
                if let action = selectAreaAction {
                    action()
                }
            } label: {
                HStack(spacing: 0) {
                    OText(
                        title,
                        token: .subtitle_03
                    )
                    Spacer()
                    if isSelected {
                        if let additionalInfo = additionalInfo {
                            OText(
                                additionalInfo,
                                token: .body_02,
                                color: OColors.text02.swiftUIColor
                            ).hPadding(12)
                        }
                    }
                }
                .padding(.leading, 16)
                .vPadding(16)
            }
            Spacer()
            Toggle("", isOn: $isSelected)
                .labelsHidden()
                .tint(isSelected ? OColors.oPrimary.swiftUIColor : OColors.uiDisable02.swiftUIColor)
                .padding(.trailing, 16)
                .vPadding(13)
        }
    }
}
