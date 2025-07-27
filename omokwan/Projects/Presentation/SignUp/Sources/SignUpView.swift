//
//  SignUpView.swift
//  SignUp
//
//  Created by 김동준 on 10/1/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Base

public struct SignUpView: View {
    let store: StoreOf<SignUpFeature>
    @ObservedObject var viewStore: ViewStoreOf<SignUpFeature>

    public init(store: StoreOf<SignUpFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    @FocusState private var focusedField: SignUpTextFieldType?
    
    private enum SignUpTextFieldType {
        case nickname
    }
    
    public var body: some View {
        signUpBody
            .oLoading(isPresent: viewStore.isLoading)
            .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var signUpBody: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    viewStore.send(.navigateToBack)
                }
            ).padding(.bottom, 34)
            nicknameSettingView.hPadding(20)
            Spacer()
            OButton(
                title: "다음",
                status: viewStore.state.isNextButtonEnable ? .default : .disable,
                type: .default,
                action: {
                    viewStore.send(.nextButtonTapped)
                }
            ).padding(20)
        }
    }
    
    private var nicknameSettingView: some View {
        VStack(spacing: 0) {
            OText(
                "닉네임을 설정해주세요.",
                token: .display,
                color: OColors.text01.swiftUIColor
            )
            .greedyWidth(.leading)
            .padding(.bottom, 16)
            OText(
                "2~10글자 사이의 한글, 영문, 숫자로 입력해주세요.",
                token: .body_long_02,
                color: OColors.text02.swiftUIColor
            )
            .greedyWidth(.leading)
            .padding(.bottom, 24)
            OTextField<SignUpTextFieldType>(
                text: viewStore.$nickname,
                focusedField: $focusedField,
                focusedFieldType: .nickname,
                placeholder: "ex.오목완",
                errorMessage: mappingNicknameErrorMessage(viewStore.nicknameValidStatus),
                textMaxCount: 10
            )
        }
    }
}

private extension SignUpView {
    func mappingNicknameErrorMessage(_ status: SignUpFeature.State.NicknameValidStatus?) -> String {
        guard let status = status else { return "" }
        
        switch status {
        case .empty, .valid:
            return ""
        case .duplicated:
            return "이미 사용중인 아이디 입니다."
        case .invalidFormat:
            return "2~10글자 사이의 한글 혹은 영문만 사용해주세요."
        }
    }
}

// MARK: About Alert
private extension SignUpView {
    var alertView: some View {
        Group {
            if let alertCase = viewStore.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        viewStore.send(.alertAction(.dismiss))
                    }
                }
            }
        }
    }
}
