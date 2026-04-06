//
//  OCheckbox.swift
//  DesignSystem
//
//  Created by 김동준 on 11/19/24
//

import SwiftUI

public struct OCheckbox: View {
    let status: OCheckboxStatus
    @Binding var isChecked: Bool
    
    public init(
        status: OCheckboxStatus,
        isChecked: Binding<Bool>
    ) {
        self.status = status
        self._isChecked = isChecked
    }
    
    public var body: some View {
        switch status {
        case .default, .disable:
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .resizedToFit(18,18)
                .foregroundColor(color)
                .padding(3)
                .onTapGesture {
                    isChecked.toggle()
                }
        case .onlyCheck:
            Button {
                isChecked.toggle()
            } label: {
                isChecked
                    ? OImages.icCheck.swiftUIImage
                    : OImages.icCheckDisable.swiftUIImage
                
            }
        }
    }
    
    var color: Color {
        switch status {
        case .default:
            return isChecked
                ? OColors.uiPrimary.swiftUIColor
                : OColors.stroke03.swiftUIColor
        case .disable:
            return isChecked
                ? OColors.uiDisable02.swiftUIColor
                : OColors.strokeDisable.swiftUIColor
        default:
            return .clear
        }
    }
}

public enum OCheckboxStatus {
    case `default`
    case disable
    case onlyCheck
}
