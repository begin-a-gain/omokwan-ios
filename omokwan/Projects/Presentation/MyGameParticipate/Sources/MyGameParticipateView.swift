//
//  MyGameParticipateView.swift
//  MyGameParticipate
//
//  Created by 김동준 on 1/1/25
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Base
import Domain

public struct MyGameParticipateView: View {
    private let store: StoreOf<MyGameParticipateFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MyGameParticipateFeature>
    @FocusState private var passwordFocusedField: PasswordField?

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
        .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
            alertView
        }
        .oLoading(isPresent: viewStore.isLoadingProgress)
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
                "대국 이름, 대국코드, 대국장으로 검색하기",
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
            if viewStore.isLoading {
                shimmerView
            } else {
                gameRoomCards
            }
        }
    }
    
    var shimmerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<10, id: \.self) { index in
                GameRoomCardView(
                    isLoading: viewStore.isLoading,
                    roomInfo: .init(),
                    categories: [],
                    buttonAction: {}
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(20)
    }
    
    var gameRoomCards: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewStore.gameRoomInformationList, id: \.id) { roomInfo in
                GameRoomCardView(
                    isLoading: viewStore.isLoading,
                    roomInfo: roomInfo,
                    categories: viewStore.categories,
                    buttonAction: {
                        viewStore.send(.participateButtonTapped(roomInfo))
                    }
                )
                .id(roomInfo.id)
            }
            
            if viewStore.hasNext {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewStore.send(.fetchInfoList(pageNumber: viewStore.currentPage + 1, trigger: .pagination))
                }
            }
    }
}

private extension MyGameParticipateView {
    var alertView: some View {
        Group {
            if let alertCase = viewStore.alertCase {
                switch alertCase {
                case .error(let error):
                    errorAlertView(error)
                case .participateDoubleCheck(let roomInfo):
                    participateDoubleCheckAlertView(roomInfo: roomInfo)
                case .password(let roomInfo):
                    passwordAlertView(roomInfo)
                case .passwordError:
                    passwordErrorAlertView
                }
            }
        }
    }
    
    func participateDoubleCheckAlertView(roomInfo: GameRoomInformation) -> some View {
        OAlert(
            type: .default,
            title: "대국에 참여하시겠습니까?",
            content: "'\(roomInfo.name)' 대국을 시작해보세요.",
            primaryButtonAction: {
                viewStore.send(.alertAction(.dismiss))
            },
            secondaryButtonAction: {
                viewStore.send(.alertParticipateButtonTapped(roomInfo))
            }
        )
    }
    
    func errorAlertView(_ networkError: NetworkError) -> some View {
        CommonErrorAlertView(networkError) {
            viewStore.send(.alertAction(.dismiss))
        }
    }
    
    func passwordAlertView(_ roomInfo: GameRoomInformation) -> some View {
        CommonPasswordAlertView(
            focusedField: $passwordFocusedField,
            thousandsPlaceText: viewStore.$thousandsPlace,
            hundredsPlaceText: viewStore.$hundredsPlace,
            tensPlaceText: viewStore.$tensPlace,
            onesPlaceText: viewStore.$onesPlace,
            primaryButtonAction: { viewStore.send(.passwordAlertCancelButtonTapped) },
            secondaryButtonAction: { viewStore.send(.passwordAlertConfirmButtonTapped(roomInfo)) }
        )
    }
    
    var passwordErrorAlertView: some View {
        OAlert(
            type: .defaultOnlyOK,
            title: "비밀번호 오류",
            content: "다시 확인해주세요.",
            primaryButtonAction: {
                viewStore.send(.alertAction(.dismiss))
            }
        )
    }
}
