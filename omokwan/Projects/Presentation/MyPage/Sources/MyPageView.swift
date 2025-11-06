//
//  MyPageView.swift
//  MyPage
//
//  Created by 김동준 on 11/2/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Util

public struct MyPageView: View {
    private let store: StoreOf<MyPageFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MyPageFeature>
    
    public init(store: StoreOf<MyPageFeature>) {
        self.store = store
        viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        myPageBody
            .onAppear { viewStore.send(.onAppear) }
    }
    
    private var myPageBody: some View {
        VStack(spacing: 0) {
            ONavigationBar(title: "마이페이지")
            avatarSection
            ScrollView {
                VStack(spacing: 0) {
                    myGameSection
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                    
                    generalSection
                        .padding(.bottom, 24)
                    
                    infoSection
                        .padding(.bottom, 20)
                    
                    bottomButtonView
                        .padding(.bottom, 60)
                }
            }
            .background(OColors.ui02.swiftUIColor)
        }
    }
}

private extension MyPageView {
    var avatarSection: some View {
        HStack(spacing: 10) {
            circleAvatarView
            nameView
        }
        .hPadding(20)
        .vPadding(16)
        .background(OColors.uiBackground.swiftUIColor)
    }
    
    var circleAvatarView: some View {
        Circle()
            .fill(OColors.oPrimary.swiftUIColor.opacity(0.1))
            .stroke(OColors.strokePrimary.swiftUIColor, lineWidth: 1)
            .frame(86, 86)
            .overlay {
                OText(
                    String(viewStore.userInfo.nickname.prefix(1)),
                    token: .display_02,
                    color: OColors.textPrimary.swiftUIColor
                )
            }
    }
    
    var nameView: some View {
        Button {
            viewStore.send(.nicknameTapped)
        } label: {
            HStack(spacing: 4) {
                OText(
                    "\(viewStore.userInfo.nickname) 님",
                    token: .headline
                )
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .height(12)
                        .foregroundStyle(OColors.strokePrimaryOpa40.swiftUIColor)
                        .blendMode(.destinationOver)
                }
                .compositingGroup()
                
                OImages.icArrowRight.swiftUIImage
                    .renderingMode(.template)
                    .resizedToFit(16, 16)
                    .foregroundStyle(OColors.icon01.swiftUIColor)
            }
            .greedyWidth(.leading)
        }
    }
}

private extension MyPageView {
    var myGameSection: some View {
        MyPageTitleContentsView(
            title: "나의 대국",
            content: {
                VStack(spacing: 0) {
                    titleContentButton(
                        title: "진행 중인 대국",
                        content: "123",
                        isShowArrowButton: true
                    )
                    titleContentButton(
                        title: "완료한 대국",
                        content: "123",
                        isShowArrowButton: true
                    )
                }
            }
        )
        .hPadding(20)
    }
}

private extension MyPageView {
    var generalSection: some View {
        MyPageTitleContentsView(
            title: "일반",
            content: {
                titleContentButton(
                    title: "알림",
                    isShowArrowButton: true
                )
            }
        )
        .hPadding(20)
    }
}

private extension MyPageView {
    var infoSection: some View {
        MyPageTitleContentsView(
            title: "정보",
            content: {
                VStack(spacing: 0) {
                    titleContentButton(
                        title: "현재 앱 버전",
                        content: "ver \(Bundle.main.fullVersion)"
                    )
                    titleContentButton(
                        title: "이용약관",
                        isShowArrowButton: true
                    )
                    titleContentButton(
                        title: "개인정보처리방침",
                        isShowArrowButton: true
                    )
                }
            }
        )
        .hPadding(20)
    }
}

private extension MyPageView {
    func titleContentButton(
        title: String,
        content: String? = nil,
        isShowArrowButton: Bool = false,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        HStack(spacing: 0) {
            OText(
                title,
                token: .subtitle_03
            )
            
            Spacer()
            
            if let content = content {
                OText(
                    content,
                    token: .body_02,
                    color: OColors.text02.swiftUIColor
                )
            }
            
            if isShowArrowButton {
                Button {
                    buttonAction?()
                } label: {
                    OImages.icArrowRight.swiftUIImage
                        .renderingMode(.template)
                        .resizedToFit(16, 16)
                        .foregroundStyle(OColors.icon02.swiftUIColor)
                        .padding(.leading, 8)
                }
            }
        }
        .vPadding(6)
        .padding(16)
    }
}

private extension MyPageView {
    var bottomButtonView: some View {
        HStack(spacing: 0) {
            Button {
                viewStore.send(.logoutButtonTapped)
            } label: {
                OText("로그아웃", token: .title_02)
                    .vPadding(14)
                    .hPadding(16)
            }
            
            verticalDividerView
                .hPadding(8)
            
            Button {
                
            } label: {
                OText("회원탈퇴", token: .title_02)
                    .vPadding(14)
                    .hPadding(16)
            }
        }
        .greedyWidth()
    }
    
    var verticalDividerView: some View {
        Rectangle()
            .frame(width: 2, height: 16)
            .foregroundColor(OColors.stroke03.swiftUIColor)
    }
}
