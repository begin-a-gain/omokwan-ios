//
//  SignInView.swift
//  SignIn
//
//  Created by 김동준 on 8/25/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Base

public struct SignInView: View {
    @Bindable private var store: StoreOf<SignInFeature>
    @Environment(\.openURL) private var openURL

    public init(store: StoreOf<SignInFeature>) {
        self.store = store
    }
    
    public var body: some View {
        signInBody
            .navigationBarBackButtonHidden(true)
            .oLoading(isPresent: store.isLoading)
            .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var signInBody: some View {
        VStack(spacing: 0) {
            titleSection
                .padding(.bottom, 28)
            
            OImages.imgOmok.swiftUIImage
                .resizable()
                .scaledToFit()
                .hPadding(24)
                .padding(.bottom, 10)
            
            loginButton
                .padding(.bottom, 16)
            policyView
        }
        .greedyHeight(.bottom)
    }
    
    private var loginButton: some View {
        HStack(spacing: 20) {
            Button {
                store.send(.kakaoButtonTapped)
            } label: {
                OImages.icKakao.swiftUIImage
            }
            Button {
                store.send(.appleButtonTapped)
            } label: {
                OImages.icApple.swiftUIImage
            }
        }
    }
    
    private var policyView: some View {
        VStack(spacing: 8) {
            OText(
                "회원가입을 진행할 경우, 아래의 정책에 대해 동의한 것으로 간주합니다.",
                token: .caption,
                color: OColors.text02.swiftUIColor
            )
            HStack(spacing: 12) {
                Button {
                    openTermsOfService()
                } label: {
                    OText(
                        "이용약관",
                        token: .caption,
                        color: OColors.text02.swiftUIColor,
                        isUnderline: true
                    )
                }
                Button {
                    openPrivacyPolicy()
                } label: {
                    OText(
                        "개인정보처리방침",
                        token: .caption,
                        color: OColors.text02.swiftUIColor,
                        isUnderline: true
                    )
                }
            }
        }
        .greedyWidth()
        .hPadding(20)
        .padding(.top, 20)
        .padding(.bottom, 32)
    }
}

// MARK: About Alert
private extension SignInView {
    var alertView: some View {
        Group {
            if let alertCase = store.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        store.send(.alertAction(.dismiss))
                    }
                }
            }
        }
    }
}

private extension SignInView {
    var titleSection: some View {
        VStack(spacing: 12) {
            OImages.imgSplashLogo.swiftUIImage
                .renderingMode(.template)
                .foregroundStyle(OColors.uiPrimary.swiftUIColor)
            
            titleText
        }
    }
    
    var titleText: some View {
        var text: AttributedString {
            var text = AttributedString("오늘의 목표 완료")

            for char in ["오", "목", "완"] {
                if let range = text.range(of: char) {
                    text[range].foregroundColor = OColors.oPrimary.swiftUIColor
                }
            }
            return text
        }
        
        return Text(text)
            .font(.suit(token: .body_light))
    }
}

private extension SignInView {
    func openTermsOfService() {
        guard let url = URL(string: "https://www.notion.so/32d2d47341bb80a3947bc2e79f86c679?source=copy_link") else { return }
        openURL(url)
    }
    
    func openPrivacyPolicy() {
        guard let url = URL(string: "https://www.notion.so/32d2d47341bb806688c7d006d65a498e?source=copy_link") else { return }
        openURL(url)
    }
}
