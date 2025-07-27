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
import Base

public struct MainView: View {
    private let store: StoreOf<MainFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MainFeature>

    public init(store: StoreOf<MainFeature>) {
        self.store = store
        self.viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                let hasBottomSafeArea = proxy.safeAreaInsets.bottom > 0

                mainContentView(hasBottomSafeArea)
                    .ignoresSafeArea(edges: .bottom)
                
                MainBottomTabBarShape()
                    .fill(OColors.oWhite.swiftUIColor)
                    .shadow(
                        color: OColors.oPrimary.swiftUIColor.opacity(0.3),
                        radius: 20,
                        x: 0, y: 0
                    )
                    .height(MainUtil.getBottomTabBarHeight(hasBottomSafeArea))
                    .greedyHeight(.bottom)
                    .ignoresSafeArea(edges: .bottom)
                
                MainBottomTabBarView(viewStore: viewStore, hasBottomSafeArea: hasBottomSafeArea)
                    .height(MainUtil.getBottomTabBarHeight(hasBottomSafeArea) + (MainConstants.circleButtonSize / 2))
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
                .modifier(CommonSheetModifier(detent: [.medium]))
        }
    }
    
    private func mainContentView(_ hasBottomSafeArea: Bool) -> some View {
        WithViewStore(store, observe: \.selectedTab) { currentTab in
            Group {
                switch currentTab.state {
                case .myGame:
                    MyGameView(
                        store: store.scope(state: \.myGameState, action: \.myGameAction)
                    ).padding(.bottom, MainUtil.getBottomTabBarHeight(hasBottomSafeArea))
                case .myPage:
                    ProfileView()
                        .padding(.bottom, MainUtil.getBottomTabBarHeight(hasBottomSafeArea))
                }
            }
        }
    }
}

// TODO: Remove This View
public struct ProfileView: View {
    public var body: some View {
        VStack {
            Text("Profile View")
            Button {
                
            } label: {
                Text("Logout")
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
                }
            }
        }
    }
}
