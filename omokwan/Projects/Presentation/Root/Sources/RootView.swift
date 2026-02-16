//
//  RootView.swift
//  Root
//
//  Created by 김동준 on 11/20/24
//

import SwiftUI
import ComposableArchitecture
import SignIn
import Main
import Splash
import SignUp
import Base

public struct RootView: View {
    @Bindable private var store: StoreOf<RootFeature>

    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        let rootPathStore = store.scope(state: \.root, action: \.root)
        GeometryReader { proxy in
            ZStack {
                switch rootPathStore.state {
                case .splash:
                    if let store = rootPathStore.scope(state: \.splash, action: \.splash) {
                        SplashView(store: store)
                    }
                case .signIn:
                    if let store = rootPathStore.scope(state: \.signIn, action: \.signIn) {
                        SignInCoordinatorView(store: store)
                    }
                case .main:
                    if let mainStore = rootPathStore.scope(state: \.main, action: \.main) {
                        MainCoordinatorRootView(store: mainStore)
                    }
                case .signUpDone:
                    if let store = rootPathStore.scope(state: \.signUpDone, action: \.signUpDone) {
                        SignUpDoneView(store: store)
                    }
                }
            }
            .oToast(
                isPresented: $store.isToastPresented,
                message: store.state.toastMessage,
                bottomPadding: getToastBottomPadding(DeviceInfo.shared.hasHomeIndicator)
            )
            .onAppear {
                DeviceInfo.shared.update(bottom: proxy.safeAreaInsets.bottom)
            }
        }
    }
}

private extension RootView {
    func getToastBottomPadding(_ hasBottomSafeArea: Bool) -> Double {
        let bottomTabBarHeight = DeviceInfo.shared.bottomTabBarHeight
        let defaultPadding: Double = 24
        
        switch store.root {
        case .main(let mainState):
            return mainState.navigationPath.contains { if case .gameDetail = $0 { true } else { false } }
                ? bottomTabBarHeight
                : bottomTabBarHeight + defaultPadding
        default:
            return defaultPadding
        }
    }
}
