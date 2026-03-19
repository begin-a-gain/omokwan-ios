//
//  CommonPasswordAlertView.swift
//  Base
//
//  Created by 김동준 on 9/21/25
//

import Foundation
import SwiftUI
import DesignSystem

public struct CommonPasswordAlertView: View {
    @FocusState.Binding private var focusedField: PasswordField?
    @Binding private var thousandsPlaceText: String
    @Binding private var hundredsPlaceText: String
    @Binding private var tensPlaceText: String
    @Binding private var onesPlaceText: String

    private let primaryButtonAction: () -> Void
    private let secondaryButtonAction: () -> Void

    public init(
        focusedField: FocusState<PasswordField?>.Binding,
        thousandsPlaceText: Binding<String>,
        hundredsPlaceText: Binding<String>,
        tensPlaceText: Binding<String>,
        onesPlaceText: Binding<String>,
        primaryButtonAction: @escaping () -> Void,
        secondaryButtonAction: @escaping () -> Void
    ) {
        self._focusedField = focusedField
        self._thousandsPlaceText = thousandsPlaceText
        self._hundredsPlaceText = hundredsPlaceText
        self._tensPlaceText = tensPlaceText
        self._onesPlaceText = onesPlaceText
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
    }
    
    public var body: some View {
        OAlertContentView(
            type: .default,
            primaryButtonAction: {
                focusedField = nil
                primaryButtonAction()
            },
            secondaryButtonAction: {
                secondaryButtonAction()
            },
            content: {
                VStack(spacing: 16) {
                    OText(
                        "대국 비밀번호 설정",
                        token: .headline
                    )
                    HStack(spacing: 8) {
                        PasswordFieldView(
                            text: $thousandsPlaceText,
                            focusedField: $focusedField,
                            focusedFieldType: .thousandsPlace,
                            refreshAction: { passwordRefreshAction() }
                        )
                        PasswordFieldView(
                            text: $hundredsPlaceText,
                            focusedField: $focusedField,
                            focusedFieldType: .hundredsPlace,
                            refreshAction: { passwordRefreshAction() }
                        )
                        PasswordFieldView(
                            text: $tensPlaceText,
                            focusedField: $focusedField,
                            focusedFieldType: .tensPlace,
                            refreshAction: { passwordRefreshAction() }
                        )
                        PasswordFieldView(
                            text: $onesPlaceText,
                            focusedField: $focusedField,
                            focusedFieldType: .onesPlace,
                            refreshAction: { passwordRefreshAction() }
                        )
                    }
                }.vPadding(4)
            }
        ).onAppear {
            focusedField = .thousandsPlace
            passwordRefreshAction()
        }
    }
    
    private func passwordRefreshAction() {
        thousandsPlaceText = ""
        hundredsPlaceText = ""
        tensPlaceText = ""
        onesPlaceText = ""
    }
}
