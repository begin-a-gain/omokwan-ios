//
//  NotificationView.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct NotificationView: View {
    private let store: StoreOf<NotificationFeature>
    
    public init(store: StoreOf<NotificationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                title: "알림",
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    store.send(.navigateToBack)
                },
                trailingIcon: OImages.icSetting.swiftUIImage,
                trailingIconAction:  {
                    store.send(.settingButtonTapped)
                }
            )
            
            Spacer()
        }
        .background(OColors.uiBackground.swiftUIColor)
        .onAppear {
            store.send(.onAppear)
        }
    }
}
