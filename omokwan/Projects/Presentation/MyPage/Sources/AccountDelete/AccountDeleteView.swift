//
//  AccountDeleteView.swift
//  MyPage
//
//  Created by 김동준 on 11/24/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Base
import Domain

public struct AccountDeleteView: View {
    private let store: StoreOf<AccountDeleteFeature>
    @ObservedObject private var viewStore: ViewStoreOf<AccountDeleteFeature>
    @FocusState private var focusedField: TextFieldType?
    
    private enum TextFieldType {
        case otherReason
    }
    
    public init(store: StoreOf<AccountDeleteFeature>) {
        self.store = store
        viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        accountDeleteBody
            .onAppear { viewStore.send(.onAppear) }
            .oLoading(isPresent: viewStore.isLoading)
            .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var accountDeleteBody: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                VStack(spacing: 0) {
                    infoView
                }
            }
            bottomButton
        }
    }
}

private extension AccountDeleteView {
    var navigationBar: some View {
        ONavigationBar(
            title: "회원 탈퇴",
            leadingIcon: OImages.icArrowLeft.swiftUIImage,
            leadingIconAction: {
                viewStore.send(.navigateToBack)
            }
        )
    }
    
    var bottomButton: some View {
        OButton(
            title: "탈퇴하기",
            status: viewStore.isBottomButtonEnabled ? .default : .disable,
            type: .default,
            size: .big
        ) {
            focusedField = nil
            viewStore.send(.deleteAccountButtonTapped)
        }
        .vPadding(16)
        .hPadding(20)
    }
}

private extension AccountDeleteView {
    var infoView: some View {
        VStack(spacing: 24) {
            titleSection
            guideText
            checkBoxView
                .padding(.bottom, 40)
        }
        .padding(20)
   }
    
    var titleSection: some View {
        let content: String = """
        탈퇴 이유를 알려주세요.
        오목완이 더 나은 서비스가 되는데
        많은 도움이 될거에요.
        """
        
        return Text(content)
            .font(.suit(token: .display))
            .foregroundStyle(OColors.text01.swiftUIColor)
            .multilineTextAlignment(.leading)
            .lineLimit(3)
            .greedyWidth(.leading)
    }
    
    var guideText: some View {
        OText(
            "최소 1개 이상 선택해주세요.",
            token: .body_long_02,
            color: OColors.text02.swiftUIColor
        ).greedyWidth(.leading)
    }
    
    var checkBoxView: some View {
        VStack(spacing: 24) {
            ForEach(AccountDeleteReason.allCases, id: \.self) { reason in
                let isSelected = viewStore.selectedReasons.contains(reason)

                VStack(spacing: 10) {
                    Button {
                        viewStore.send(.reasonToggled(reason))
                    } label: {
                        HStack(spacing: 8) {
                            checkBox(isSelected)
                            OText(
                                reason.title,
                                token: .subtitle_03
                            )
                        }
                    }.greedyWidth(.leading)
                    if reason == .other && viewStore.isOtherSelected {
                        OTextField<TextFieldType>(
                            text: viewStore.$otherReasonText,
                            focusedField: $focusedField,
                            focusedFieldType: .otherReason,
                            placeholder: "탈퇴 이유를 50자 이내로 작성해주세요."
                        )
                        .onAppear {
                            focusedField = .otherReason
                        }
                    }
                }
                .greedyWidth(.leading)
                .animation(.easeInOut(duration: 0.1), value: viewStore.selectedReasons)
            }
        }
    }
    
    func checkBox(_ isSelected: Bool) -> Image {
        isSelected
        ? OImages.icCheckboxChecked.swiftUIImage
        : OImages.icCheckboxUnchecked.swiftUIImage
    }
}

private extension AccountDeleteView {
    var alertView: some View {
        Group {
            if let alertCase = viewStore.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        viewStore.send(.alertAction(.dismiss))
                    }
                case .deleteCompleted:
                    deleteCompletedAlertView
                }
            }
        }
    }
    
    var deleteCompletedAlertView: some View {
        OAlert(
            type: .defaultOnlyOK,
            title: "탈퇴가 완료되었어요.",
            content: "언젠가 다시 도전해봐요. 기다릴게요!",
            primaryButtonAction: {
                viewStore.send(.alertAction(.dismiss))
                viewStore.send(.deleteAccountAlertButtonTapped)
            }
       )
    }
}
