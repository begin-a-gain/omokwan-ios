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
import Util
import UIKit

public struct SplashView: View {
    @Bindable private var store: StoreOf<SplashFeature>

    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }
    
    public var body: some View {
        splashBody
            .navigationBarBackButtonHidden(true)
            .oLoading(isPresent: store.isLoading)
            .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
            .onAppear {
                store.send(.onAppear)
                AnalyticsManager.shared.logEvent(
                    "splash_view",
                    parameters: [
                        "screen_name": "splash_view",
                        "description": "임시 테스트"
                    ]
                )
            }
    }
    
    private var splashBody: some View {
        VStack(spacing: 12) {
            OImages.imgSplashLogo.swiftUIImage
            OText(
                "OMOKWAN",
                token: .body_light,
                color: .white
            )
        }
        .greedyFrame()
        .background(OColors.uiPrimary.swiftUIColor)
    }
}

// MARK: About Alert
private extension SplashView {
    var alertView: some View {
        Group {
            if let alertCase = store.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        store.send(.alertAction(.dismiss))
                    }
                case .forceUpdate:
                    forceUpdateAlertView
                }
            }
        }
    }
    
    var forceUpdateAlertView: some View {
        OAlert(
            type: .defaultOnlyOK,
            title: "업데이트가 필요해요",
            content: "원활한 오목완 서비스 이용을 위해 최신 버전으로 업데이트 해주세요.",
            primaryButtonTitle: "업데이트",
            primaryButtonAction: {
                // TODO: 오목완 앱스토어 주소 나오면 그걸로 수정
                openAppStore()
            }
        )
    }
    
    func openAppStore() {
        guard let url = URL(string: "itms-apps://itunes.apple.com") else { return }
        UIApplication.shared.open(url)
    }
}
