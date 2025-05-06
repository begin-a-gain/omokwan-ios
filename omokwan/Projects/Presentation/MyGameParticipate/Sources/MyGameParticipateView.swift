//
//  MyGameParticipateView.swift
//  MyGameParticipate
//
//  Created by 김동준 on 1/1/25
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct MyGameParticipateView: View {
    let store: StoreOf<MyGameParticipateFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyGameParticipateFeature>

    public init(store: StoreOf<MyGameParticipateFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        myGameParticipateBody
        .onAppear {
            viewStore.send(.onAppear)
        }
        .sheet(store: store.scope(state: \.$categorySheet, action: \.categorySheet)) { store in
            MyGameParticipateCategorySheetView(store: store)
                .modifier(CommonSheetModifier(detent: [.medium]))
        }
    }
    
    private var myGameParticipateBody: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                title: "대국 참여하기",
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    viewStore.send(.navigateToBack)
                }
            )
            participateHeaderView
            roomScrollView
        }
        .background(OColors.uiDisable01.swiftUIColor)
    }
}

// MARK: 헤더 뷰
private extension MyGameParticipateView {
    var participateHeaderView: some View {
        VStack(spacing: 16) {
            searchView
            filterView
        }
        .vPadding(16)
        .hPadding(20)
        .background(OColors.uiBackground.swiftUIColor)
    }
}

// MARK: 서치 뷰
private extension MyGameParticipateView {
    var searchView: some View {
        HStack(spacing: 0) {
            OImages.icSearch.swiftUIImage
                .renderingMode(.template)
                .resizedToFit(20,20)
                .foregroundStyle(OColors.icon02.swiftUIColor)
            
            Spacer().width(4)
            
            TextField(
                "대국 이름, 대국방 ID, 방장으로 검색하기",
                text: viewStore.$searchText
            )
            .multilineTextAlignment(.leading)
            .font(.suit(token: .body_01))
            .foregroundStyle(OColors.text01.swiftUIColor)
            .greedyWidth(.leading)
            
            if !viewStore.searchText.isEmpty {
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
                viewStore.send(.searchBarClearButtonTapped)
            } label: {
                OImages.icCancel.swiftUIImage
                    .renderingMode(.template)
                    .resizedToFit(20, 20)
                    .foregroundStyle(OColors.icon01.swiftUIColor)
            }
        }
    }
}

// MARK: 필터 뷰
private extension MyGameParticipateView {
    var filterView: some View {
        HStack(spacing: 8) {
            if viewStore.isResetFilterButtonVisible {
                resetFilterButtonView
            }
            availableParticipateRoomView
            categoryFilterView
            Spacer()
        }
        .animation(.easeInOut, value: viewStore.isResetFilterButtonVisible)
    }
    
    var resetFilterButtonView: some View {
        Button {
            viewStore.send(.resetFilterButtonTapped)
        } label: {
            OImages.icReset.swiftUIImage.resizedToFit(20,20)
                .hPadding(12)
                .vPadding(8)
                .background(OColors.ui02.swiftUIColor)
                .cornerRadius(40)
        }
    }
    
    var availableParticipateRoomView: some View {
        FilterCategoryView(
            type: .availableRoom,
            isSelected: viewStore.isAvailableParticipateRoomSelected,
            action: {
                viewStore.send(.availableParticipateRoomFilterTapped)
            }
        )
    }
    
    var categoryFilterView: some View {
        FilterCategoryView(
            numOfCategory: viewStore.numOfCategory,
            type: .category,
            isSelected: viewStore.isCategoryFilterSelected,
            action: {
                viewStore.send(.categoryFilterTapped)
            }
        )
    }
}

// MARK: About Room Scroll View
private extension MyGameParticipateView {
    var roomScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewStore.gameRoomInformationList, id: \.self) { roomInfo in
                    GameRoomCardView(roomInfo: roomInfo)
                }
            }.clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(20)
        }
    }
}
