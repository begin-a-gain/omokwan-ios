//
//  PasswordFieldView.swift
//  Base
//
//  Created by 김동준 on 9/21/25
//

import SwiftUI
import DesignSystem

struct PasswordFieldView: View {
    @Binding private var text: String
    @FocusState.Binding private var focusedField: PasswordField?
    private let focusedFieldType: PasswordField
    private let refreshAction: () -> Void
    
    init(
        text: Binding<String>,
        focusedField: FocusState<PasswordField?>.Binding,
        focusedFieldType: PasswordField,
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
        .onChange(of: text) { oldValue, newValue in
            let filtered = newValue.filter(\.isNumber)
            let limited = String(filtered.prefix(1))
            
            if text != limited {
                text = limited
                return
            }
            
            if !newValue.isEmpty {
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

