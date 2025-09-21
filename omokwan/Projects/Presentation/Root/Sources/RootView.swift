//
//  RootView.swift
//  Root
//
//  Created by 김동준 on 11/20/24
//

import SwiftUI
import ComposableArchitecture
import SignIn
import SignUp
import Main
import Splash

public struct RootView: View {
    private let store: StoreOf<RootFeature>
    @ObservedObject private var viewStore: ViewStoreOf<RootFeature>

    public init(store: StoreOf<RootFeature>) {
        self.store = store
        self.viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let hasBottomSafeArea = proxy.safeAreaInsets.bottom > 0
            
            ZStack {
                let pathStore = store.scope(state: \.path, action: \.path)
                switch pathStore.state {
                case .main:
                    if let mainStore = pathStore.scope(state: \.main, action: \.main) {
                        MainCoordinatorRootView(store: mainStore)
                    }
                default:
                    NavigationStackStore(store.scope(state: \.navigationPath, action: \.navigatePathAction)) {
                        rootView
                    } destination: { store in
                        destinationView(store)
                    }
                }
            }.oToast(
                isPresented: viewStore.$isToastPresented,
                message: viewStore.toastMessage,
                bottomPadding: getToastBottomPadding(hasBottomSafeArea)
            )
        }
    }
}

private extension RootView {
    @ViewBuilder
    private var rootView: some View {
        let pathStore = store.scope(state: \.path, action: \.path)
        switch pathStore.state {
        case .signIn:
            if let signInStore = pathStore.scope(state: \.signIn, action: \.signIn) {
                SignInView(store: signInStore)
            }
        case .signUp:
            if let signUpStore = pathStore.scope(state: \.signUp, action: \.signUp) {
                SignUpView(store: signUpStore)
            }
        case .signUpDone:
            if let signUpDoneStore = pathStore.scope(state: \.signUpDone, action: \.signUpDone) {
                SignUpDoneView(store: signUpDoneStore)
            }
        case .splash:
            if let splashStore = pathStore.scope(state: \.splash, action: \.splash) {
                SplashView(store: splashStore)
            }
        default:
            EmptyView()
        }
    }
}

private extension RootView {
    @ViewBuilder
    private func destinationView(_ store: RootFeature.RootPath.State) -> some View {
        switch store {
        case .signIn:
            CaseLet(\RootFeature.RootPath.State.signIn, action: RootFeature.RootPath.Action.signIn) { store in
                SignInView(store: store)
            }
        case .signUp:
            CaseLet(\RootFeature.RootPath.State.signUp, action: RootFeature.RootPath.Action.signUp) { store in
                SignUpView(store: store)
            }
        case .signUpDone:
            CaseLet(\RootFeature.RootPath.State.signUpDone, action: RootFeature.RootPath.Action.signUpDone) { store in
                SignUpDoneView(store: store)
            }
        case .splash:
            CaseLet(\RootFeature.RootPath.State.splash, action: RootFeature.RootPath.Action.splash) { store in
                SplashView(store: store)
            }
        default:
            EmptyView()
        }
    }
}

private extension RootView {
    func getToastBottomPadding(_ hasBottomSafeArea: Bool) -> Double {
        let bottomTabBarHeight = MainUtil.getBottomTabBarHeight(hasBottomSafeArea)
        let defaultPadding: Double = 24
        
        switch viewStore.path {
        case .main(let mainState):
            return mainState.path.contains { if case .gameDetail = $0 { true } else { false } }
                ? bottomTabBarHeight
                : bottomTabBarHeight + defaultPadding
        default:
            return defaultPadding
        }
    }
}
