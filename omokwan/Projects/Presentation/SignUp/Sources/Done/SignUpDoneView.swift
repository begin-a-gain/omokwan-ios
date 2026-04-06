//
//  SignUpDoneView.swift
//  SignUp
//
//  Created by 김동준 on 10/4/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Base

public struct SignUpDoneView: View {
    @Bindable private var store: StoreOf<SignUpDoneFeature>

    public init(store: StoreOf<SignUpDoneFeature>) {
        self.store = store
    }
    
    public var body: some View {
        signUpDoneBody
            .navigationBarBackButtonHidden(true)
            .oLoading(isPresent: store.isLoading)
            .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var signUpDoneBody: some View {
        VStack(spacing: 0) {
            titleText
                .padding(.bottom, 64)
                .padding(.leading, 32)
                .greedyWidth(.leading)
            
            OImages.imgWelcome.swiftUIImage
                .resizable()
                .scaledToFit()
                .hPadding(40)
                .padding(.bottom, 46)
            
            OButton(
                title: "오목완 시작하기",
                status: .default,
                type: .default,
                action: {
                    store.send(.startButtonTapped)
                }
            ).padding(20)
        }
        .greedyHeight(.bottom)
    }
    
    var titleText: some View {
        var text: AttributedString {
            let textString = """
            환영해요!
            오늘의 목표를
            완료하러 가볼까요?
            """
            var text = AttributedString(textString)

            for char in ["오", "목", "완"] {
                if let range = text.range(of: char) {
                    text[range].foregroundColor = OColors.oPrimary.swiftUIColor
                }
            }
            return text
        }
        
        return Text(text)
            .font(.suit(token: .title_light))
            .lineLimit(3)
    }
}

// MARK: About Alert
private extension SignUpDoneView {
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
