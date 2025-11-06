//
//  EditNicknameView.swift
//  MyPage
//
//  Created by 김동준 on 11/3/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Base

public struct EditNicknameView: View {
    private let store: StoreOf<EditNicknameFeature>
    @ObservedObject private var viewStore: ViewStoreOf<EditNicknameFeature>
    
    public init(store: StoreOf<EditNicknameFeature>) {
        self.store = store
        viewStore = ViewStore(store) { $0 }
    }
    
    @FocusState private var focusedField: TextFieldType?
    
    private enum TextFieldType {
        case nickname
    }
    
    public var body: some View {
        editNicknameBody
            .onAppear { viewStore.send(.onAppear) }
            .oLoading(isPresent: viewStore.isLoading)
            .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var editNicknameBody: some View {
        VStack(spacing: 0) {
            navigationBar
                .padding(.bottom, 32)
            
            nicknameSettingView
            
            Spacer()
            
            buttonView
        }
    }
}

private extension EditNicknameView {
    var navigationBar: some View {
        ONavigationBar(
            title: "닉네임 변경",
            leadingIcon: OImages.icArrowLeft.swiftUIImage,
            leadingIconAction: {
                viewStore.send(.navigateToBack)
            }
        )
    }
}

private extension EditNicknameView {
    var nicknameSettingView: some View {
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
            
            OTextField<TextFieldType>(
                text: viewStore.$nickname,
                focusedField: $focusedField,
                focusedFieldType: .nickname,
                placeholder: "ex.오목완",
                errorMessage: mappingNicknameErrorMessage(viewStore.nicknameValidStatus),
                textMaxCount: 10,
                trailingIcon: OImages.icCancel.swiftUIImage,
                trailingIconButtonAction: {
                    viewStore.send(.binding(.set(\.$nickname, "")))
                }
            )
        }
        .hPadding(20)
    }
    
    func mappingNicknameErrorMessage(_ status: EditNicknameFeature.State.NicknameValidStatus?) -> String {
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

private extension EditNicknameView {
    var buttonView: some View {
        OButton(
            title: "변경하기",
            status: viewStore.isButtonEnabled ? .default : .disable,
            type: .default
        ) {
            viewStore.send(.nicknameUpdateButtonTapped)
        }
        .vPadding(16)
        .hPadding(20)
    }
}

private extension EditNicknameView {
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
