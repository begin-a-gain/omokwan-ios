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
    private let store: StoreOf<GameDetailFeature>
    @ObservedObject private var viewStore: ViewStoreOf<GameDetailFeature>
    private let availableWidth: CGFloat
    private let hPadding: CGFloat = 20
    
    public init(store: StoreOf<GameDetailFeature>) {
        let deviceWidth: CGFloat = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows.first { $0.isKeyWindow }?.bounds.width ?? 376
        
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        self.availableWidth = deviceWidth - (hPadding * 2)
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
        .sheet(store: store.scope(state: \.$userAvatarInfoSheet, action: \.userAvatarInfoSheet)) { store in
            UserAvatarInfoView(store: store)
                .modifier(DynamicSheetModifier())
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
                dateDictionary: viewStore.dateDictionary,
                availableWidth: availableWidth,
                hPadding: hPadding
            )
            .padding(.bottom, 8)
            
            DetailUserAvatarView(
                availableWidth: availableWidth,
                hPadding: hPadding,
                userInfos: [
                    .init(userID: 5, nickname: "오목왕빡빡이"),
                    .init(userID: 2, nickname: "오목왕갹갹이"),
                    .init(userID: 3, nickname: "빡빡이"),
                    .init(userID: 4, nickname: "갹갹이"),
                    .init(userID: 1, nickname: "나는빡빡이다")
                ],
                action: { id in
                    viewStore.send(.avatarButtonTapped(id))
                }
            )
            .padding(.bottom, 20)
            
        }
        .background(OColors.uiBackground.swiftUIColor)
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
                case .kickOut(let nickname):
                    kickOutAlertView(nickname)
                }
            }
        }
    }
    
    func kickOutAlertView(_ nickname: String) -> some View {
        OAlert(
            type: .default,
            title: "이 멤버를 내보낼까요?",
            content: "해당 멤버에 대한 기록이 대국에서 사라지며  복구 할 수 없어요.",
            primaryButtonAction: {
                viewStore.send(.alertAction(.dismiss))
            },
            secondaryButtonTitle: "내보내기",
            secondaryButtonBackgroundColor: OColors.uiAlert.swiftUIColor,
            secondaryButtonAction: {
                viewStore.send(.kickOutAlertButtonTapped(nickname))
            }
        )
    }
}
