//
//  PasswordView.swift
//  Base
//
//  Created by 김동준 on 5/26/25
//

import SwiftUI
import DesignSystem

public struct PasswordView: View {
    @FocusState private var passwordFocusedField: PasswordFocusField?
    
    let title: String
    let thousandsPlace: Binding<String>
    let hundredsPlace: Binding<String>
    let tensPlace: Binding<String>
    let onesPlace: Binding<String>
    let primaryButtonAction: () -> Void
    let secondaryButtonAction: () -> Void
    let refreshAction: () -> Void
    
    public init(
        title: String,
        thousandsPlace: Binding<String>,
        hundredsPlace: Binding<String>,
        tensPlace: Binding<String>,
        onesPlace: Binding<String>,
        primaryButtonAction: @escaping () -> Void,
        secondaryButtonAction: @escaping () -> Void,
        refreshAction: @escaping () -> Void
    ) {
        self.title = title
        self.thousandsPlace = thousandsPlace
        self.hundredsPlace = hundredsPlace
        self.tensPlace = tensPlace
        self.onesPlace = onesPlace
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
        self.refreshAction = refreshAction
    }
    
    public var body: some View {
        OAlertContentView(
            type: .default,
            primaryButtonAction: {
                passwordFocusedField = nil
                primaryButtonAction()
            },
            secondaryButtonAction: {
                secondaryButtonAction()
            },
            content: {
                VStack(spacing: 16) {
                    OText(
                        title,
                        token: .headline
                    )
                    passwordField
                }.vPadding(4)
            }
        ).onAppear {
            passwordFocusedField = .thousandsPlace
            refreshAction()
        }
    }
}

private extension PasswordView {
    var passwordField: some View {
        HStack(spacing: 8) {
            MyGameAddPasswordField(
                text: thousandsPlace,
                focusedField: $passwordFocusedField,
                focusedFieldType: .thousandsPlace,
                refreshAction: { refreshAction() }
            )
            MyGameAddPasswordField(
                text: hundredsPlace,
                focusedField: $passwordFocusedField,
                focusedFieldType: .hundredsPlace,
                refreshAction: { refreshAction() }
            )
            MyGameAddPasswordField(
                text: tensPlace,
                focusedField: $passwordFocusedField,
                focusedFieldType: .tensPlace,
                refreshAction: { refreshAction() }
            )
            MyGameAddPasswordField(
                text: onesPlace,
                focusedField: $passwordFocusedField,
                focusedFieldType: .onesPlace,
                refreshAction: { refreshAction() }
            )
        }
    }
}
