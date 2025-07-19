//
//  SignUpDoneView.swift
//  SignUp
//
//  Created by 김동준 on 10/4/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct SignUpDoneView: View {
    let store: StoreOf<SignUpDoneFeature>
    @ObservedObject var viewStore: ViewStoreOf<SignUpDoneFeature>

    public init(store: StoreOf<SignUpDoneFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        signUpDoneBody
            .navigationBarBackButtonHidden(true)
            .oLoading(isPresent: viewStore.isLoading)
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
