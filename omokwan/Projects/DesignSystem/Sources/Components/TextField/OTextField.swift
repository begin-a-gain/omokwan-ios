//
//  OTextField.swift
//  DesignSystem
//
//  Created by 김동준 on 10/4/24
//

import SwiftUI

public struct OTextField<FocusedFieldType: Hashable>: View {
    @Binding private var text: String
    @FocusState.Binding private var focusedField: FocusedFieldType?
    private let focusedFieldType: FocusedFieldType
    private let label: String?
    private let isLabel: Bool
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let errorMessage: String
    private let textMaxCount: Int?
    private let isSecureField: Bool
    private let isDisabled: Bool
    private let isReadOnly: Bool
    private let leadingIcon: Image?
    private let leadingIconButtonAction: (() -> Void)?
    private let trailingIcon: Image?
    private let trailingIconButtonAction: (() -> Void)?
    private var type: OTextFieldType {
        getOTextFieldType()
    }
    
    public init(
        text: Binding<String>,
        focusedField: FocusState<FocusedFieldType?>.Binding,
        focusedFieldType: FocusedFieldType,
        label: String? = nil,
        isLabel: Bool = true,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        errorMessage: String = "",
        textMaxCount: Int? = nil,
        isSecureField: Bool = false,
        isDisabled: Bool = false,
        isReadOnly: Bool = false,
        leadingIcon: Image? = nil,
        leadingIconButtonAction: (() -> Void)? = nil,
        trailingIcon: Image? = nil,
        trailingIconButtonAction: (() -> Void)? = nil
    ) {
        self._text = text
        self._focusedField = focusedField
        self.focusedFieldType = focusedFieldType
        self.label = label
        self.isLabel = isLabel
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.errorMessage = errorMessage
        self.textMaxCount = textMaxCount
        self.isSecureField = isSecureField
        self.isDisabled = isDisabled
        self.isReadOnly = isReadOnly
        self.leadingIcon = leadingIcon
        self.leadingIconButtonAction = leadingIconButtonAction
        self.trailingIcon = trailingIcon
        self.trailingIconButtonAction = trailingIconButtonAction
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            if isLabel {
                if let label = label {
                    labelView(label)
                }
            }
            
            HStack(spacing: 12) {
                if let leadingIcon = leadingIcon {
                    leadingIconView(image: leadingIcon)
                }
                if isSecureField {
                    secureFieldView
                } else {
                    normalTextFieldView
                }
                if let trailingIcon = trailingIcon, !text.isEmpty {
                    trailingIconView(image: trailingIcon)
                }
            }
            .greedyWidth()
            .padding(16)
            .background(backgroundColor)
            .modifier(OTextFieldModifier(type: type))
            .cornerRadius(8)
            
            VStack(spacing: 0) {
                Spacer().height(4)
                HStack(alignment: .top, spacing: 10) {
                    if !errorMessage.isEmpty {
                        errorMessageView(errorMessage)
                    }
                    Spacer()
                    if let textMaxCount = textMaxCount {
                        textCountView(textMaxCount)
                    }
                }
                .greedyWidth()
                .hPadding(16)
            }
        }
    }
    
    private func labelView(_ label: String) -> some View {
        HStack(spacing: 0) {
            OText(
                label,
                token: .subtitle_02,
                color: OColors.text01.swiftUIColor
            ).greedyWidth(.leading)
        }.hPadding(16)
    }
    
    private func leadingIconView(image: Image) -> some View {
        image.resizedToFit(20, 20)
    }
    
    private func trailingIconView(image: Image) -> some View {
        Button {
            if let action = trailingIconButtonAction {
                action()
            }
        } label: {
            image.resizedToFit(20, 20)
        }
    }
    
    private var secureFieldView: some View {
        SecureField(
            "",
            text: $text,
            prompt: Text(
                placeholder
            )
            .font(.suit(token: .body_02))
            .foregroundColor(OColors.textDisable.swiftUIColor)
        )
        .multilineTextAlignment(.leading)
        .focused($focusedField, equals: focusedFieldType)
        .keyboardType(keyboardType)
        .font(.suit(token: .body_02))
        .foregroundStyle(OColors.text01.swiftUIColor)
        .greedyWidth(.leading)
        .disabled(isReadOnly ? true : isDisabled)
    }
    
    private var normalTextFieldView: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .font(.suit(token: .body_02))
                .foregroundStyle(OColors.textDisable.swiftUIColor)
        )
        .multilineTextAlignment(.leading)
        .focused($focusedField, equals: focusedFieldType)
        .keyboardType(keyboardType)
        .font(.suit(token: .body_02))
        .foregroundStyle(textColor)
        .greedyWidth(.leading)
        .disabled(isReadOnly ? true : isDisabled)
    }
    
    private func errorMessageView(_ errorMessage: String) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            OText(
                errorMessage,
                token: .caption,
                color: errorMessageColor,
                alignment: .leading,
                lineLimit: 2
            )
        }
    }
    
    private func textCountView(_ textMaxCount: Int) -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            OText(
                "\(text.count)",
                token: .caption,
                color: textCountColor(textMaxCount)
            )
            OText(
                "/",
                token: .caption,
                color: textCountColor(textMaxCount)
            )
            OText(
                "\(textMaxCount)",
                token: .caption,
                color: textCountColor(textMaxCount)
            )
        }
    }
}

// MARK: About Color
private extension OTextField {
    func getOTextFieldType() -> OTextFieldType {
        if !errorMessage.isEmpty {
            return .error
        } else {
            if isDisabled { return .disable }
            if isReadOnly { return .readOnly }
            
            guard focusedField != nil else {
                if text.isEmpty {
                    return .default
                } else {
                    return .filled
                }
            }
            
            return .focus
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .default, .focus, .filled, .error:
            return .clear
        case .readOnly, .disable:
            return OColors.uiDisable01.swiftUIColor
        }
    }
    
    private var textColor: Color {
        switch type {
        case .focus, .filled, .error, .readOnly:
            return OColors.text01.swiftUIColor
        case .default:
            return OColors.textDisable.swiftUIColor
        case .disable:
            return OColors.textOnDisable.swiftUIColor
        }
    }
    
    private var errorMessageColor: Color {
        switch type {
        case .error:
            OColors.textAlert.swiftUIColor
        default:
            OColors.text02.swiftUIColor
        }
    }
    
    private func textCountColor(_ textMaxCount: Int) -> Color {
        if text.count > textMaxCount {
            OColors.textAlert.swiftUIColor
        } else {
            errorMessageColor
        }
    }
}
