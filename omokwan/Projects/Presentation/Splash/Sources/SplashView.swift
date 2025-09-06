//
//  SplashView.swift
//  Splash
//
//  Created by 김동준 on 9/5/25
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Base

public struct SplashView: View {
    private let store: StoreOf<SplashFeature>
    @ObservedObject private var viewStore: ViewStoreOf<SplashFeature>

    public init(store: StoreOf<SplashFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        splashBody
            .navigationBarBackButtonHidden(true)
            .oLoading(isPresent: viewStore.isLoading)
            .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
    }
    
    private var splashBody: some View {
        VStack(spacing: 0) {
            Text("Splash~ Hi~")
        }
    }
}

// MARK: About Alert
private extension SplashView {
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
