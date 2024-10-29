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

@main
struct RootApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate

    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?[AppKeys.KAKAOKEY] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView()
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
