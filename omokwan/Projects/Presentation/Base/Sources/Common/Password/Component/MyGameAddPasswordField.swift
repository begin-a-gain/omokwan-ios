//
//  MyGameAddPasswordField.swift
//  MyGameAdd
//
//  Created by 김동준 on 12/22/24
//

import SwiftUI
import DesignSystem

struct MyGameAddPasswordField: View {
    @Binding private var text: String
    @FocusState.Binding private var focusedField: PasswordFocusField?
    private let focusedFieldType: PasswordFocusField
    private let refreshAction: () -> Void
    
    init(
        text: Binding<String>,
        focusedField: FocusState<PasswordFocusField?>.Binding,
        focusedFieldType: PasswordFocusField,
        refreshAction: @escaping () -> Void
    ) {
        self._text = text
        self._focusedField = focusedField
        self.focusedFieldType = focusedFieldType
        self.refreshAction = refreshAction
    }
    
    var body: some View {
        ZStack {
            ZStack {
                if text.isEmpty {
                    OText(
                        "0",
                        token: .body_02,
                        color: OColors.textDisable.swiftUIColor
                    )
                    .frame(20, 20)
                    .padding(16)
                } else {
                    OText(
                        text,
                        token: .body_02
                    )
                    .frame(20, 20)
                    .padding(16)
                }
            }.overlay(RoundedRectangle(cornerRadius: 8).stroke(strokeColor, lineWidth: 1.0))

            TextField(
                "",
                text: $text
            )
            .font(.suit(token: .body_02))
            .focused($focusedField, equals: focusedFieldType)
            .keyboardType(.numberPad)
            .foregroundStyle(.clear)
            .frame(20, 20)
            .padding(16)
            .tint(text.isEmpty ? OColors.strokeFocus.swiftUIColor : .clear)
            .allowsHitTesting(false)
        }
        .onTapGesture {
            focusedField = .thousandsPlace
            refreshAction()
        }
        .onChange(of: text) { value in
            if !value.isEmpty {
                switch focusedFieldType {
                case .thousandsPlace:
                    focusedField = .hundredsPlace
                case .hundredsPlace:
                    focusedField = .tensPlace
                case .tensPlace:
                    focusedField = .onesPlace
                case .onesPlace:
                    focusedField = nil
                }
            }
        }
    }
    
    private var strokeColor: Color {
        if focusedField == focusedFieldType {
            OColors.strokeFocus.swiftUIColor
        } else {
            OColors.stroke02.swiftUIColor
        }
    }
}
