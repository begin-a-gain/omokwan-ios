//
//  NotificationCard.swift
//  Notification
//
//  Created by jumy on 3/14/26.
//

import SwiftUI
import Foundation
import DesignSystem
import Domain

struct NotificationCard: View {
    private let isLoading: Bool
    private let notification: NotificationInfo
    private let action: (() -> Void)?
    
    init(
        isLoading: Bool = false,
        notification: NotificationInfo,
        action: (() -> Void)? = nil
    ) {
        self.isLoading = isLoading
        self.notification = notification
        self.action = action
    }
    
    var body: some View {
        switch notification.type {
        case .invited:
            VStack(alignment: .leading, spacing: 12) {
                infoView
                
                Button {
                    action?()
                } label: {
                    OText(
                        "참여하기",
                        token: .subtitle_02,
                        color: OColors.ui01.swiftUIColor
                    )
                    .hPadding(16)
                    .vPadding(10)
                    .background(OColors.uiPrimary.swiftUIColor)
                    .cornerRadius(8)
                }
            }
            .padding(20)
            .background(OColors.uiBackground.swiftUIColor)
        default:
            Button {
                action?()
            } label: {
                infoView
                    .padding(20)
                    .background(OColors.uiBackground.swiftUIColor)
            }
        }
    }
}

private extension NotificationCard {
    var infoView: some View {
        HStack(spacing: 32) {
            VStack(spacing: 8) {
                titleSection
                subTitleSection
                dateSection
            }
            
            if !notification.isRead {
                Circle()
                    .frame(8, 8)
                    .foregroundStyle(OColors.uiPrimary.swiftUIColor)
            }
        }
    }
    
    var titleSection: some View {
        OText(
            notificationTitle,
            token: .subtitle_02,
            color: OColors.text02.swiftUIColor,
            lineLimit: nil
        )
        .greedyWidth(.leading)
        .shimmer(isLoading, cornerRadius: 4)
    }
    
    var subTitleSection: some View {
        OText(
            notificationSubTitle,
            token: .title_02,
            color: OColors.text01.swiftUIColor,
            alignment: .leading,
            lineLimit: nil
        )
        .greedyWidth(.leading)
        .shimmer(isLoading, cornerRadius: 4)
    }
    
    var dateSection: some View {
        HStack(spacing: 8) {
            OText(
                dateText,
                token: .caption,
                color: OColors.text02.swiftUIColor
            )
            .greedyWidth(.leading)
        }
        .shimmer(isLoading, cornerRadius: 4)
    }
}

private extension NotificationCard {
    var notificationTitle: String {
        switch notification.type {
        case .invited:
            return "\(notification.title) 대국 초대"
        case .left:
            return "\(notification.title) 대국 멤버 탈퇴"
        case .hostChanged:
            return "\(notification.title) 대국장 변경"
        case .joined:
            return "\(notification.title) 대국 멤버 참여"
        }
    }
    
    var notificationSubTitle: String {
        switch notification.type {
        case .invited:
            return "대국에 초대되었어요. 참여해볼까요?"
        case .left:
            return "\(notification.targetName ?? "-")님이 대국에서 나갔어요."
        case .hostChanged:
            let previousHostName = notification.previousHostName ?? "-"
            let newHostName = notification.newHostName ?? "-"
            return "대국장이 \(previousHostName)님에서 \(newHostName)님으로 변경되었어요."
        case .joined:
            return "\(notification.targetName ?? "-")님이 대국에 참여했어요."
        }
    }
    
    var dateText: String {
        let interval = max(Int(Date.now.timeIntervalSince(notification.createdDate)), 0)
        
        if interval < 60 { return "방금 전" }
        
        let minutes = interval / 60
        if minutes < 60 { return "\(minutes)분 전" }
        
        let hours = minutes / 60
        if hours < 24 { return "\(hours)시간 전" }
        
        let days = hours / 24
        return "\(days)일 전"
    }
}
