//
//  GameDetailView.swift
//  GameDetail
//
//  Created by 김동준 on 5/12/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Util

public struct GameDetailView: View {
    let store: StoreOf<GameDetailFeature>
    @ObservedObject var viewStore: ViewStoreOf<GameDetailFeature>
    
    public init(store: StoreOf<GameDetailFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            gameDetailBody
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
    
    private var gameDetailBody: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                title: viewStore.gameTitle,
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    viewStore.send(.navigateToBack)
                },
                trailingIcon: OImages.icMenu.swiftUIImage,
                trailingIconAction: {
                    viewStore.send(.menuButtonTapped)
                }
            )
            
            stickyScrollView
//                .padding(.bottom, 8)
            
//            userAvatarView
//                .padding(.bottom, 20)
            
        }
        .background(OColors.uiBackground.swiftUIColor)
    }
}

// MARK: About ScrollView
private extension GameDetailView {
    var stickyScrollView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(viewStore.dateDictionary.keys.sorted(), id: \.self) { key in
                        if let dates = viewStore.dateDictionary[key] {
                            Section(header: monthHeaderView(key)) {
                                monthSectionBody(headerString: key, dates: dates)
                                    .padding(.bottom, 20)
                            }
                            .background(OColors.uiBackground.swiftUIColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let today = viewStore.now.seoulNow.formattedString(format: DateFormatConstants.scrollCalendarFormat)
                    scrollProxy.scrollTo(today, anchor: .top)
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    func monthHeaderView(_ headerString: String) -> some View {
        ZStack(alignment: .bottom) {
            OText(
                headerString,
                token: .title_02,
                color: OColors.text01.swiftUIColor
            )
            .greedyWidth()
            .vPadding(8)
            .background(OColors.ui02.swiftUIColor)
            
            Rectangle()
                .height(2)
                .greedyWidth()
                .foregroundStyle(OColors.stroke02.swiftUIColor)
        }
        .cornerRadius(8, corners: [.topLeft, .topRight])
        .hPadding(20)
    }
    
    func monthSectionBody(headerString: String, dates: [Date]) -> some View {
        VStack(spacing: 0) {
            ForEach(dates, id: \.self) { date in
                HStack(spacing: 0) {
                    dateView(date)
                        .greedyWidth(.leading)
                }.id(date.formattedString(format: DateFormatConstants.scrollCalendarFormat))
            }
        }
        .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
        .hPadding(20)
    }
    
    func dateView(_ date: Date) -> some View {
        OText(
            date.formattedString(format: DateFormatConstants.detailGameSectionRowDateFormat),
            token: .subtitle_03,
            color: OColors.text01.swiftUIColor
        )
        .width(30)
        .vPadding(20)
        .hPadding(4)
        .hPadding(12)
        .background(OColors.ui02.swiftUIColor)
    }
}

private extension GameDetailView {
    var userAvatarView: some View {
        Rectangle()
            .height(50)
            .greedyWidth()
    }
}

private extension GameDetailView {
    var buttonTitle: String {
        viewStore.isBottomButtonEnable
        ? "오목두기"
        : "오늘자 오목을 이미 두었어요."
    }
    
    var bottomButtonView: some View {
        OButton(
            title: buttonTitle,
            status: viewStore.isBottomButtonEnable ? .default : .disable,
            type: .default
        )
        .vPadding(16)
        .hPadding(20)
    }
    
    var buttonView: some View {
        OButton(
            title: buttonTitle,
            status: viewStore.isBottomButtonEnable ? .default : .disable,
            type: .default
        )
        .vPadding(16)
        .hPadding(20)
    }
    
    var bottomShadowView: some View {
        RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
            .fill(OColors.oWhite.swiftUIColor)
            .shadow(
                color: OColors.oPrimary.swiftUIColor.opacity(0.3),
                radius: 20,
                x: 0, y: 0
            )
    }
}
