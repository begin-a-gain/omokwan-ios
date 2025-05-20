//
//  OInputField.swift
//  DesignSystem
//
//  Created by 김동준 on 12/1/24
//

import SwiftUI

public struct OInputField: View {
    let title: String
    let value: String?
    let buttonAction: () -> Void
    
    public init(
        title: String,
        value: String? = nil,
        buttonAction: @escaping () -> Void
    ) {
        self.title = title
        self.value = value
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        HStack(spacing:0) {
            HStack(spacing: 8) {
                OText(
                    title,
                    token: .subtitle_03
                )
                Spacer()
                Button {
                    buttonAction()
                } label: {
                    if let value = value {
                        OText(
                            value,
                            token: .subtitle_03,
                            color: OColors.text02.swiftUIColor
                        )
                    }
                    OImages.icArrowRight.swiftUIImage.resizedToFit(16,16).vPadding(2)
                }
            }
        }.padding(16)
    }
}
