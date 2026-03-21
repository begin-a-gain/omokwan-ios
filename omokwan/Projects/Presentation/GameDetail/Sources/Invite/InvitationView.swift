//
//  InvitationView.swift
//  GameDetail
//
//  Created by jumy on 3/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Base
import Domain

public struct InvitationView: View {
    @Bindable private var store: StoreOf<InvitationFeature>
    @FocusState private var isSearchFieldFocused: Bool
    
    public init(store: StoreOf<InvitationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            invitationBody
                .ignoresSafeArea(edges: .bottom)
                .padding(.bottom, GameDetailConstants.bottomPadding)
            
            bottomShadowView
                .height(DeviceInfo.shared.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)

            bottomButtonView
                .padding(.bottom, DeviceInfo.shared.homeIndicatorHeight)
                .height(DeviceInfo.shared.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)
        }
        .background(OColors.uiBackground.swiftUIColor)
        .onAppear {
            store.send(.onAppear)
        }
        .oLoading(isPresent: store.isLoading)
        .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
            alertView
        }
    }
    
    private var invitationBody: some View {
        VStack(spacing: 0) {
            navigationBar
            
            if !store.selectedUserInfoList.isEmpty {
                SelectedUserInfoRowView(
                    userInfoList: store.selectedUserInfoList,
                    action: { info in store.send(.userInfoRowCardTapped(info)) }
                )
                .padding(.top, 16)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    )
                )
            }
            
            searchView
                .hPadding(20)
                .vPadding(16)
                .background(OColors.uiBackground.swiftUIColor)
            ScrollView {
                if store.isShimmerLoading {
                    shimmerView
                } else {
                    userCards
                }
            }
            .background(OColors.ui02.swiftUIColor)
        }
        .animation(.easeInOut(duration: 0.22), value: store.selectedUserInfoList)
    }
    
    private var navigationBar: some View {
        ONavigationBar(
            title: "대국 초대하기",
            leadingIcon: OImages.icArrowLeft.swiftUIImage,
            leadingIconAction: {
                store.send(.navigateToBack)
            }
        )
    }
}

private extension InvitationView {
    var bottomShadowView: some View {
        RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
            .fill(OColors.oWhite.swiftUIColor)
            .shadow(
                color: OColors.oPrimary.swiftUIColor.opacity(0.3),
                radius: 20,
                x: 0, y: 0
            )
    }
    
    var bottomButtonView: some View {
        OButton(
            title: "초대하기",
            status: store.isBottomButtonEnable ? .default : .disable,
            type: .default
        ) {
            store.send(.inviteButtonTapped)
        }
        .vPadding(16)
        .hPadding(20)
    }
}

private extension InvitationView {
    var searchView: some View {
        HStack(spacing: 0) {
            OImages.icSearch.swiftUIImage
                .renderingMode(.template)
                .resizedToFit(20,20)
                .foregroundStyle(OColors.icon02.swiftUIColor)
                .padding(.trailing, 4)
                        
            TextField(
                "이름으로 검색하기",
                text: $store.nickname
            )
            .focused($isSearchFieldFocused)
            .multilineTextAlignment(.leading)
            .font(.suit(token: .body_01))
            .foregroundStyle(OColors.text01.swiftUIColor)
            .greedyWidth(.leading)
            
            if !store.nickname.isEmpty {
                clearButtonView
            }
        }
        .vPadding(8)
        .hPadding(12)
        .background(OColors.ui03.swiftUIColor)
        .cornerRadius(8)
    }
    
    var clearButtonView: some View {
        HStack(spacing: 0) {
            Spacer().width(12)
            
            Button {
                store.send(.set(\.nickname, ""))
            } label: {
                OImages.icCancel.swiftUIImage
                    .renderingMode(.template)
                    .resizedToFit(20, 20)
                    .foregroundStyle(OColors.icon01.swiftUIColor)
            }
        }
    }
}

private extension InvitationView {
    var shimmerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<10, id: \.self) { _ in
                UserInfoRowCardView(
                    isLoading: true,
                    element: .init(),
                    selectedUserInfoList: []
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(20)
    }
    
    var userCards: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(store.allUserInfoList.enumerated()), id: \.element.userID) { _, element in
                UserInfoRowCardView(
                    element: element,
                    selectedUserInfoList: store.selectedUserInfoList,
                    action: {
                        isSearchFieldFocused = false
                        store.send(.userInfoRowCardTapped(element))
                    }
                )
            }
            
            if store.hasNext {
                progressView
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(20)
    }
    
    var progressView: some View {
        OLottieView(.omokLoading)
            .frame(64, 64)
            .onAppear {
                guard let nextCursor = store.nextCursor else { return }
                store.send(.fetchUserList(cursor: nextCursor))
            }
    }
}

private extension InvitationView {
    var alertView: some View {
        Group {
            if let alertCase = store.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        store.send(.alertAction(.dismiss))
                    }
                }
            }
        }
    }
}
