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
    private let store: StoreOf<SignUpDoneFeature>
    @ObservedObject private var viewStore: ViewStoreOf<SignUpDoneFeature>

    public init(store: StoreOf<SignUpDoneFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        signUpDoneBody
            .navigationBarBackButtonHidden(true)
            .oLoading(isPresent: viewStore.isLoading)
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
                    viewStore.send(.startButtonTapped)
                }
            ).padding(20)
        }
    }
}

// MARK: About Alert
private extension SignUpDoneView {
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
