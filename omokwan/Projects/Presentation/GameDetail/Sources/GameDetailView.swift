//
//  GameDetailView.swift
//  GameDetail
//
//  Created by 김동준 on 5/12/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Base
import Dependencies

public struct GameDetailView: View {
    private let store: StoreOf<GameDetailFeature>
    private let calendarStore: StoreOf<StickyCalendarFeature>
    @ObservedObject private var viewStore: ViewStoreOf<GameDetailFeature>
    @Dependency(\.analyticsUseCase) private var analyticsUseCase
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
        self.calendarStore = store.scope(state: \.stickyCalendarState, action: \.stickyCalendarAction)
    }
    
    public var body: some View {
        ZStack {
            gameDetailBody
                .ignoresSafeArea(edges: .bottom)
                .padding(.bottom, GameDetailConstants.bottomPadding)

            bottomShadowView
                .height(DeviceInfo.shared.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)

            bottomButtonView
                .padding(.bottom, DeviceInfo.shared.homeIndicatorHeight)
                .height(DeviceInfo.shared.bottomTabBarHeight)
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
        .sheet(isPresented: Binding(
            get: { viewStore.isComboSheetPresented },
            set: { viewStore.send(.setComboSheet($0)) })
        ) {
            DetailComboSheetView(comboCount: viewStore.comboCount)
                .modifier(CommonSheetModifier(detent: [.height(726 + DeviceInfo.shared.homeIndicatorHeight)]))
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
            
            ZStack(alignment: .top) {
                StickyScrollView(
                    store: store.scope(state: \.stickyCalendarState, action: \.stickyCalendarAction),
                    availableWidth: availableWidth,
                    hPadding: hPadding
                )

                if calendarStore.isTopProgressVisible {
                    OLottieView(.omokLoading)
                        .frame(64, 64, .top)
                }
            }
            .padding(.bottom, 8)
            
            DetailUserAvatarView(
                availableWidth: availableWidth,
                hPadding: hPadding,
                userInfos: viewStore.gameUserInfos,
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
        switch viewStore.bottomButtonType {
        case .possible, .impossible:
            "오목두기"
        case .alreadyDone:
            "오늘자 오목을 이미 두었어요."
        }
    }
    
    var bottomButtonStatus: OButtonStatus {
        switch viewStore.bottomButtonType {
        case .possible: .default
        case .alreadyDone, .impossible: .disable
        }
    }
    
    var bottomButtonView: some View {
        OButton(
            title: buttonTitle,
            status: bottomButtonStatus,
            type: .default
        ) {
            viewStore.send(.updateTodayOmokStatus)
            analyticsUseCase.track(.putStone)
        }
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
                case let .kickOut(nickname, userID):
                    kickOutAlertView(
                        nickname: nickname,
                        userID: userID
                    )
                }
            }
        }
    }
    
    func kickOutAlertView(
        nickname: String,
        userID: Int
    ) -> some View {
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
                viewStore.send(
                    .kickOutAlertButtonTapped(nickname, userID)
                )
                analyticsUseCase.track(.kickUser)
            }
        )
    }
}
