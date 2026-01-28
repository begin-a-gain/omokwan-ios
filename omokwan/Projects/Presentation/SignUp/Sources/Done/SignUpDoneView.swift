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
            Spacer().height(164)
            Rectangle()
                .background(.gray)
                .greedyWidth()
                .hPadding(38)
                .height(394)
            Spacer()
            OButton(
                title: "오목완 시작하기",
                status: .default,
                type: .default,
                action: {
                    store.send(.startButtonTapped)
                }
            ).padding(20)
        }
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
