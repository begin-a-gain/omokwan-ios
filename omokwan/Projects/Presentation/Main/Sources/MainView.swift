//
//  MainView.swift
//  Main
//
//  Created by 김동준 on 10/1/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import MyGame
import MyPage
import Base
import Domain

public struct MainView: View {
    private let store: StoreOf<MainFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MainFeature>
    @FocusState private var passwordFocusedField: PasswordField?

    public init(store: StoreOf<MainFeature>) {
        self.store = store
        self.viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                mainContentView(DeviceInfo.shared.hasHomeIndicator)
                    .ignoresSafeArea(edges: .bottom)
                
                MainBottomTabBarShape()
                    .fill(OColors.oWhite.swiftUIColor)
                    .shadow(
                        color: OColors.oPrimary.swiftUIColor.opacity(0.3),
                        radius: 20,
                        x: 0, y: 0
                    )
                    .height(DeviceInfo.shared.bottomTabBarHeight)
                    .greedyHeight(.bottom)
                    .ignoresSafeArea(edges: .bottom)
                
                MainBottomTabBarView(viewStore: viewStore)
                    .height(DeviceInfo.shared.bottomTabBarHeight + (MainConstants.circleButtonSize / 2))
                    .overlay(alignment: .top) {
                        CenterPlusFloatingActionButton() {
                            viewStore.send(.addGameButtonTapped)
                        }
                    }
                    .greedyHeight(.bottom)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
            alertView
        }
        .oLoading(isPresent: viewStore.isMainLoading)
        .sheet(store: store.scope(state: \.$mainSheet, action: \.mainSheet)) { store in
            MainSheetView(store: store)
                .modifier(CommonSheetModifier(detent: [.height(406 + DeviceInfo.shared.homeIndicatorHeight)]))
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
    
    private func mainContentView(_ hasBottomSafeArea: Bool) -> some View {
        WithViewStore(store, observe: \.selectedTab) { currentTab in
            Group {
                switch currentTab.state {
                case .myGame:
                    MyGameView(
                        store: store.scope(state: \.myGameState, action: \.myGameAction)
                    ).padding(.bottom, DeviceInfo.shared.bottomTabBarHeight)
                case .myPage:
                    MyPageView(
                        store: store.scope(state: \.myPageState, action: \.myPageAction)
                    ).padding(.bottom, DeviceInfo.shared.bottomTabBarHeight)
                }
            }
        }
    }
}

private struct CenterPlusFloatingActionButton: View {
    fileprivate let action: () -> Void
    
    fileprivate init(action: @escaping () -> Void) {
        self.action = action
    }
    
    fileprivate var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .frame(MainConstants.circleButtonSize, MainConstants.circleButtonSize)
                
                OImages.icPlus.swiftUIImage
                    .renderingMode(.template)
                    .resizedToFit(MainConstants.circleButtonSize / 2, MainConstants.circleButtonSize / 2)
                    .foregroundColor(OColors.oWhite.swiftUIColor)
                    .padding(16)
                    .background(OColors.oPrimary.swiftUIColor)
                    .clipShape(Circle())
            }
        }
    }
}

// MARK: About Alert
private extension MainView {
    var alertView: some View {
        Group {
            if let alertCase = viewStore.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        viewStore.send(.alertAction(.dismiss))
                    }
                case .logout:
                    logoutAlertView
                case .myGame(let alertCase):
                    myGameAlertView(alertCase)
                }
            }
        }
    }
    
    @ViewBuilder
    func myGameAlertView(_ alertCase: MyGameFeature.State.AlertCase) -> some View {
        switch alertCase {
        case .participateDoubleCheck(let stoneInfo):
            OAlert(
                type: .default,
                title: "대국에 다시 참여할까요?",
                content: "'\(stoneInfo.name)' 대국을 다시 시작해보세요.",
                primaryButtonAction: {
                    viewStore.send(.alertAction(.dismiss))
                },
                secondaryButtonAction: {
                    viewStore.send(.alertAction(.dismiss))
                    viewStore.send(.myGameAction(.alertParticipateButtonTapped(stoneInfo)))
                }
            )
        case .password(let stoneInfo):
            CommonPasswordAlertView(
                focusedField: $passwordFocusedField,
                thousandsPlaceText: Binding(
                    get: { viewStore.myGameState.thousandsPlace },
                    set: { viewStore.send(.myGameAction(.set(\.$thousandsPlace, $0))) }
                ),
                hundredsPlaceText: Binding(
                    get: { viewStore.myGameState.hundredsPlace },
                    set: { viewStore.send(.myGameAction(.set(\.$hundredsPlace, $0))) }
                ),
                tensPlaceText: Binding(
                    get: { viewStore.myGameState.tensPlace },
                    set: { viewStore.send(.myGameAction(.set(\.$tensPlace, $0))) }
                ),
                onesPlaceText: Binding(
                    get: { viewStore.myGameState.onesPlace },
                    set: { viewStore.send(.myGameAction(.set(\.$onesPlace, $0))) }
                ),
                primaryButtonAction: {
                    viewStore.send(.alertAction(.dismiss))
                    viewStore.send(.myGameAction(.passwordAlertCancelButtonTapped))
                },
                secondaryButtonAction: {
                    viewStore.send(.alertAction(.dismiss))
                    viewStore.send(.myGameAction(.passwordAlertConfirmButtonTapped(stoneInfo)))
                }
            )
        case .passwordError:
            OAlert(
                type: .defaultOnlyOK,
                title: "비밀번호 오류",
                content: "다시 확인해주세요.",
                primaryButtonAction: {
                    viewStore.send(.alertAction(.dismiss))
                }
            )
        }
    }
    
    var logoutAlertView: some View {
        OAlert(
            type: .default,
            title: "로그아웃할까요?",
            content: "다시 로그인하려면 계정 정보가 필요해요.",
            primaryButtonAction: {
                viewStore.send(.alertAction(.dismiss))
            },
            secondaryButtonTitle: "로그아웃",
            secondaryButtonAction: {
                viewStore.send(.alertAction(.dismiss))
                viewStore.send(.alertLogoutButtonTapped)
            }
        )
    }
}

