//
//  NotificationView.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain
import Base

public struct NotificationView: View {
    @Bindable private var store: StoreOf<NotificationFeature>
    @FocusState private var passwordFocusedField: PasswordField?
    
    public init(store: StoreOf<NotificationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        notificationBody
            .background(OColors.uiBackground.swiftUIColor)
            .onAppear {
                store.send(.onAppear)
            }
            .oLoading(isPresent: store.isProgressLoading)
            .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var notificationBody: some View {
        VStack(spacing: 0) {
            navigationBar
            notificationHeader
            ScrollView {
                if store.isLoading {
                    shimmerView
                } else {
                    VStack(spacing: 16) {
                        detailNotificationCards
                        
                        OText(
                            "* 알림은 30일 후, 자동 삭제 됩니다.",
                            token: .caption,
                            color: OColors.text02.swiftUIColor
                        )
                        .hPadding(20)
                        .greedyWidth(.leading)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(OColors.ui02.swiftUIColor)
            .animation(.easeInOut(duration: 0.2), value: store.selectedFilter)
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
        .animation(.easeInOut(duration: 0.2), value: store.selectedFilter)
    }
}

private extension NotificationView {
    var filteredNotifications: [NotificationInfo] {
        switch store.selectedFilter {
        case .all:
            store.notifications
        case .unread:
            store.unReadNotifications
        }
    }

    var detailNotificationCards: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(filteredNotifications.enumerated()), id: \.element.id) { index, notification in
                NotificationCard(
                    notification: notification,
                    action: {
                        store.send(.notificationCardTapped(notification))
                    }
                )
                .id(notification.id)
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .identity
                    )
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .hPadding(20)
        .padding(.top, 20)
    }
    
    var shimmerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<10, id: \.self) { _ in
                NotificationCard(
                    isLoading: true,
                    notification: .init()
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(20)
    }
}

private extension NotificationView {
    var alertView: some View {
        Group {
            if let alertCase = store.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        store.send(.alertAction(.dismiss))
                    }
                case .participateDoubleCheck(let notificationInfo):
                    participateDoubleCheckAlertView(notificationInfo)
                case .password(let notificationInfo):
                    passwordAlertView(notificationInfo)
                case .passwordError:
                    passwordErrorAlertView
                }
            }
        }
    }
    
    func participateDoubleCheckAlertView(_ notificationInfo: NotificationInfo) -> some View {
        OAlert(
            type: .default,
            title: "대국에 참여할까요?",
            content: "'\(notificationInfo.title)' 대국을 시작해보세요.",
            primaryButtonAction: {
                store.send(.alertAction(.dismiss))
            },
            secondaryButtonTitle: "참여하기",
            secondaryButtonAction: {
                store.send(.alertParticipateButtonTapped(notificationInfo))
            }
        )
    }
    
    func passwordAlertView(_ notificationInfo: NotificationInfo) -> some View {
        CommonPasswordAlertView(
            focusedField: $passwordFocusedField,
            thousandsPlaceText: $store.thousandsPlace,
            hundredsPlaceText: $store.hundredsPlace,
            tensPlaceText: $store.tensPlace,
            onesPlaceText: $store.onesPlace,
            primaryButtonAction: { store.send(.passwordAlertCancelButtonTapped) },
            secondaryButtonAction: { store.send(.passwordAlertConfirmButtonTapped(notificationInfo)) }
        )
    }
    
    var passwordErrorAlertView: some View {
        OAlert(
            type: .defaultOnlyOK,
            title: "비밀번호 오류",
            content: "다시 확인해주세요.",
            primaryButtonAction: {
                store.send(.alertAction(.dismiss))
            }
        )
    }
}
