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

public struct AccountDeleteView: View {
    private let store: StoreOf<AccountDeleteFeature>
    @ObservedObject private var viewStore: ViewStoreOf<AccountDeleteFeature>
    
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
            ScrollView {
                VStack(spacing: 0) {
                    navigationBar
                }
            }
            // TODO: 버튼
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
                }
            }
        }
    }
}
