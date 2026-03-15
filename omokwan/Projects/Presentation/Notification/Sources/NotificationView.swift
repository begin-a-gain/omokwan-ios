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
        notificationBody
            .background(OColors.uiBackground.swiftUIColor)
            .onAppear {
                store.send(.onAppear)
            }
    }
    
    private var notificationBody: some View {
        VStack(spacing: 0) {
            navigationBar
            notificationHeader
            Spacer()
        }
    }
    
    private var navigationBar: some View {
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
    }
}

private extension NotificationView {
    var notificationHeader: some View {
        HStack(spacing: 0) {
            NotificationFilterView(
                title: "전체",
                isSelected: store.selectedFilter == .all,
                action: {
                    store.send(.filterButtonTapped(.all))
                }
            )
            .padding(.trailing, 8)
            
            NotificationFilterView(
                title: "안 읽은 알림",
                count: store.unreadNotificationCount,
                isSelected: store.selectedFilter == .unread,
                action: {
                    store.send(.filterButtonTapped(.unread))
                }
            )
            
            Spacer()
            
            Button {
                store.send(.readAllButtonTapped)
            } label: {
                OText(
                    "모두 읽기",
                    token: .subtitle_02,
                    color: OColors.textPrimary.swiftUIColor
                )
                .vPadding(10)
            }
        }
        .hPadding(20)
        .vPadding(16)
    }
}
