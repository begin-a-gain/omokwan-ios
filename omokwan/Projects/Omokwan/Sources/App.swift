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

    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?[AppKeys.KAKAOKEY] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(
                store: Store(initialState: RootCoordinatorFeature.State(), reducer: {
                    RootCoordinatorFeature()
                })
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
