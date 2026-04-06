//
//  App.swift
//  App
//
//  Created by 김동준 on 8/21/24
//

import SwiftUI
import Root
import KakaoSDKCommon
import KakaoSDKAuth
import ComposableArchitecture

@main
struct RootApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    let isMockData = false // TODO: RemoteConfig Flag 혹은 Local Flag로 개발

    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?[AppKeys.KAKAOKEY] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(initialState: RootFeature.State()) {
                    RootFeature()
                } withDependencies: {
                    if isMockData {
                        $0.serverUseCase = .mockValue
                        $0.accountUseCase = .mockValue
                        $0.gameUseCase = .mockValue
                    }
                }
            )
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
