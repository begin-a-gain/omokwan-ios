//
//  UserAvatarInfoView.swift
//  GameDetail
//
//  Created by 김동준 on 9/15/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

struct UserAvatarInfoView: View {
    private let store: StoreOf<UserAvatarInfoFeature>
    @ObservedObject private var viewStore: ViewStoreOf<UserAvatarInfoFeature>
    
    init(store: StoreOf<UserAvatarInfoFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        userAvatarInfoBody
    }
    
    private var userAvatarInfoBody: some View {
        VStack(spacing: 0) {
            Spacer().height(12)
            OText(
                titleString,
                token: .title_02
            )
            .greedyWidth()
            .vPadding(8)
            
            VStack(spacing: 0) {
                infoView
                    .hPadding(20)
                    .vPadding(16)
                
                buttonView
                    .hPadding(20)
                    .vPadding(16)
            }
        }
        .background(OColors.uiBackground.swiftUIColor)
    }
    
    private var titleString: String {
        switch viewStore.state.participantRole {
        case .me:
            "나의 프로필"
        case .host, .other:
            "\(viewStore.state.detailUserInfo.nickname) 님의 프로필"
        }
    }
}

private extension UserAvatarInfoView {
    var infoView: some View {
        VStack(spacing: 0) {
            circleAvatarView
                .padding(.top, 16)
                .padding(.bottom, 24)
            
            statusView
                .hPadding(12)
        }
    }
    
    private var circleAvatarView: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(OColors.ui03.swiftUIColor)
                .frame(86, 86)
                .overlay {
                    OText(
                        String(viewStore.detailUserInfo.nickname.prefix(1)),
                        token: .display
                    )
                }
            
            OText(
                "\(viewStore.detailUserInfo.nickname) 님",
                token: .subtitle_03
            )
        }
    }
}

private extension UserAvatarInfoView {
    var statusView: some View {
        HStack(spacing: 0) {
            numberTextView(viewStore.detailUserInfo.combo, "오목 콤보")
                .greedyWidth()
            Rectangle()
                .frame(width: 1, height: 12)
                .foregroundColor(OColors.stroke02.swiftUIColor)
                .hPadding(8)
            numberTextView(viewStore.detailUserInfo.stones, "오목알")
                .greedyWidth()
            Rectangle()
                .frame(width: 1, height: 12)
                .foregroundColor(OColors.stroke02.swiftUIColor)
                .hPadding(8)
            numberTextView(viewStore.detailUserInfo.participantDays, "참여 일 수")
                .greedyWidth()
        }
    }
    
    func numberTextView(_ number: Int, _ text: String) -> some View {
        VStack(spacing: 8) {
            OText(
                "\(number)",
                token: .title_02
            )
            
            OText(
                text,
                token: .body_01
            )
        }
    }
}

private extension UserAvatarInfoView {
    @ViewBuilder
    var buttonView: some View {
        switch viewStore.state.participantRole {
        case .me:
            Spacer().height(40)
        case .host:
            VStack(spacing: 16) {
                shootStoneButton
                kickOutbutton
            }
        case .other:
            shootStoneButton
        }
    }
    
    var shootStoneButton: some View {
        OButton(
            title: "오목알 튕기기",
            status: .default,
            type: .default,
            size: .big
        ) {
            viewStore.send(.shootStoneButtonTapped(viewStore.detailUserInfo.nickname))
        }
    }
    
    var kickOutbutton: some View {
        OButton(
            title: "내보내기",
            status: .default,
            type: .text,
            size: .big
        ) {
            viewStore.send(
                .kickOutButtonTapped(
                    viewStore.detailUserInfo.nickname,
                    viewStore.userID
                )
            )
        }
    }
}
