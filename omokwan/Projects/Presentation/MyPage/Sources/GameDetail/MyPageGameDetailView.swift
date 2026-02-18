//
//  MyPageGameDetailView.swift
//  MyPage
//
//  Created by 김동준 on 1/14/26
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Base
import Domain

public struct MyPageGameDetailView: View {
    private let store: StoreOf<MyPageGameDetailFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MyPageGameDetailFeature>
    
    public init(store: StoreOf<MyPageGameDetailFeature>) {
        self.store = store
        viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        myPageGameDetailBody
            .onAppear { viewStore.send(.onAppear) }
            .oLoading(isPresent: viewStore.isLoading)
            .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var myPageGameDetailBody: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                if viewStore.isLoading {
                    shimmerView
                } else {
                    detailRoomCards
                }
            }
        }
        .background(OColors.ui02.swiftUIColor)
    }
}

private extension MyPageGameDetailView {
    var navigationBar: some View {
        let title = switch viewStore.type {
        case .ongoing: "진행 중인 대국"
        case .completed: "완료한 대국"
        }
        
        return ONavigationBar(
            title: title,
            leadingIcon: OImages.icArrowLeft.swiftUIImage,
            leadingIconAction: {
                viewStore.send(.navigateToBack)
            }
        )
    }
}

private extension MyPageGameDetailView {
    var shimmerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<10, id: \.self) { index in
                MyPageGameDetailCard(
                    isLoading: viewStore.isLoading,
                    roomInfo: .init(),
                    isButtonDisabled: viewStore.type == .completed
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(20)
    }
    
    var detailRoomCards: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewStore.models, id: \.gameID) { roomInfo in
                MyPageGameDetailCard(
                    isLoading: viewStore.isLoading,
                    roomInfo: roomInfo,
                    isButtonDisabled: viewStore.type == .completed,
                    buttonAction: {
                        viewStore.send(.buttonTapped(roomInfo))
                    }
                )
                .id(roomInfo.gameID)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(20)
    }
}

private extension MyPageGameDetailView {
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
