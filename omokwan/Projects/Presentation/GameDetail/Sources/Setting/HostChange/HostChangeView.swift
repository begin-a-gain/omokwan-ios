//
//  HostChangeView.swift
//  GameDetail
//
//  Created by 김동준 on 9/23/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct HostChangeView: View {
    private let store: StoreOf<HostChangeFeature>
    @ObservedObject private var viewStore: ViewStoreOf<HostChangeFeature>
    
    public init(store: StoreOf<HostChangeFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            hostChangeBody
                .ignoresSafeArea(edges: .bottom)
                .padding(.bottom, GameDetailConstants.bottomPadding)
            
            bottomShadowView
                .height(GameDetailConstants.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)

            bottomButtonView
                .padding(.bottom, GameDetailConstants.homeIndicatorHeight)
                .height(GameDetailConstants.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
    
    private var hostChangeBody: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewStore.tempUsers, id: \.self) { element in
                        radioButton(element)
                    }
                }
                .padding(.top, 24)
                .hPadding(20)
            }
        }
    }
}

private extension HostChangeView {
    var navigationBar: some View {
        ONavigationBar(
            title: "대국장 변경하기",
            leadingIcon: OImages.icArrowLeft.swiftUIImage,
            leadingIconAction: {
                viewStore.send(.navigateToBack)
            }
        )
    }
}

private extension HostChangeView {
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
            title: "대국장 변경하기",
            status: viewStore.isBottomButtonEnable ? .default : .disable,
            type: .default
        ) {
            viewStore.send(.changeButtonTapped)
        }
        .vPadding(16)
        .hPadding(20)
    }
}

private extension HostChangeView {
    func radioButton(_ element: String) -> some View {
        HStack(spacing: 0) {
            avatarView(element)
            
            infoView(element)
                .padding(.trailing, 32)
            
            OImages.icRadioUnChecked.swiftUIImage
                .resizedToFit(20, 20)
        }
        .hPadding(20)
        .vPadding(18)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
    }
    
    func avatarView(_ element: String) -> some View {
        Circle()
            .fill(OColors.ui03.swiftUIColor)
            .frame(width: 48, height: 48)
            .overlay {
                OText(
                    String(element.prefix(1)),
                    token: .display
                )
            }
    }
    
    func infoView(_ element: String) -> some View {
        VStack(spacing: 8) {
            OText(
                element,
                token: .subtitle_01
            )
            .greedyWidth(.leading)
            
            HStack(spacing: 0) {
                OText(
                    "콤보 6",
                    token: .caption
                )
                
                Rectangle()
                    .fill(OColors.stroke02.swiftUIColor)
                    .frame(width: 1, height: 12)
                    .hPadding(8)
                
                OText(
                    "오목알 60",
                    token: .caption
                )
                
                Rectangle()
                    .fill(OColors.stroke02.swiftUIColor)
                    .frame(width: 1, height: 12)
                    .hPadding(8)
                
                OText(
                    "대국 +20일 째",
                    token: .caption
                )
            }
            .greedyWidth(.leading)
        }
        .vPadding(4)
        .hPadding(8)
    }
}
