//
//  SignInView.swift
//  SignIn
//
//  Created by 김동준 on 8/25/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct SignInView: View {
    let store: StoreOf<SignInFeature>
    @ObservedObject var viewStore: ViewStoreOf<SignInFeature>

    public init(store: StoreOf<SignInFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        signInBody
            .navigationBarBackButtonHidden(true)
            .oLoading(isPresent: viewStore.isLoading)
    }
    
    private var signInBody: some View {
        VStack(spacing: 0) {
            Spacer().height(78)
            Rectangle().fill(.gray).greedyWidth().height(484).hPadding(20)
            Spacer().height(32)
            loginButton
            Spacer()
            policyView
        }
    }
    
    private var loginButton: some View {
        HStack(spacing: 20) {
            Button {
                viewStore.send(.kakaoButtonTapped)
            } label: {
                OImages.icKakao.swiftUIImage
            }
            Button {
                viewStore.send(.appleButtonTapped)
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
                    
                } label: {
                    OText(
                        "이용약관",
                        token: .caption,
                        color: OColors.text02.swiftUIColor,
                        isUnderline: true
                    )
                }
                Button {
                    
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
