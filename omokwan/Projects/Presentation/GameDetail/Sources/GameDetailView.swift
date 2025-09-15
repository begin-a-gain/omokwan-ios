//
//  GameDetailView.swift
//  GameDetail
//
//  Created by 김동준 on 5/12/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Util
import Base

public struct GameDetailView: View {
    let store: StoreOf<GameDetailFeature>
    @ObservedObject var viewStore: ViewStoreOf<GameDetailFeature>
    
    public init(store: StoreOf<GameDetailFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            gameDetailBody
                .ignoresSafeArea(edges: .bottom)
                .padding(.bottom, GameDetailConstants.bottomPadding)

            bottomShadowView
                .height(GameDetailConstants.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)

            bottomButtonView
                .padding(.bottom, GameDetailConstants.homeIndicatorHeight)
                .height(GameDetailConstants.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .oLoading(isPresent: viewStore.isLoading)
        .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
            alertView
        }
    }
    
    private var gameDetailBody: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                title: viewStore.gameTitle,
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    viewStore.send(.navigateToBack)
                },
                trailingIcon: OImages.icMenu.swiftUIImage,
                trailingIconAction: {
                    viewStore.send(.menuButtonTapped)
                }
            )
            
            StickyScrollView(
                dateDictionary: viewStore.dateDictionary
            )
//                .padding(.bottom, 8)
            
//            userAvatarView
//                .padding(.bottom, 20)
            
        }
        .background(OColors.uiBackground.swiftUIColor)
    }
}

private extension GameDetailView {
    var userAvatarView: some View {
        Rectangle()
            .height(50)
            .greedyWidth()
    }
}

private extension GameDetailView {
    var buttonTitle: String {
        viewStore.isBottomButtonEnable
        ? "오목두기"
        : "오늘자 오목을 이미 두었어요."
    }
    
    var bottomButtonView: some View {
        OButton(
            title: buttonTitle,
            status: viewStore.isBottomButtonEnable ? .default : .disable,
            type: .default
        )
        .vPadding(16)
        .hPadding(20)
    }
    
    var buttonView: some View {
        OButton(
            title: buttonTitle,
            status: viewStore.isBottomButtonEnable ? .default : .disable,
            type: .default
        )
        .vPadding(16)
        .hPadding(20)
    }
    
    var bottomShadowView: some View {
        RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
            .fill(OColors.oWhite.swiftUIColor)
            .shadow(
                color: OColors.oPrimary.swiftUIColor.opacity(0.3),
                radius: 20,
                x: 0, y: 0
            )
    }
}

private extension GameDetailView {
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
