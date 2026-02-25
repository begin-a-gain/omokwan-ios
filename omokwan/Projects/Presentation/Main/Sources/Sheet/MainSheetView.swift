//
//  AddGameSheetView.swift
//  Main
//
//  Created by 김동준 on 11/24/24
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct MainSheetView: View {
    private let store: StoreOf<MainSheetFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MainSheetFeature>
    
    public init(store: StoreOf<MainSheetFeature>) {
        self.store = store
        viewStore = ViewStore(store) { $0 }
    }
    
    var body: some View {
        OSheetView(
            title: "대국 추가하기",
            sheetContent: bodyView,
            buttonStatus: viewStore.selectedGameType == nil ? .disable : .default,
            buttonAction: {
                viewStore.send(.addGameSheetButtonTapped)
            }
        )
    }
}

// MARK: Body
private extension MainSheetView {
    var bodyView: some View {
        HStack(spacing: 16) {
            ForEach(MainSheetFeature.State.AddGameType.allCases, id: \.self) { item in
                addGameCardView(type: item)
            }
        }
        .vPadding(16)
        .hPadding(20)
    }
    
    func addGameCardView(type: MainSheetFeature.State.AddGameType) -> some View {
        Button {
            viewStore.send(.selectType(type))
        } label: {
            VStack(spacing: 16) {
                // TODO: Change Image Later
                getImage(type)
                OText(
                    getGameCardTitle(type: type),
                    token: .title_02,
                    color: viewStore.selectedGameType == type ? OColors.text01.swiftUIColor : OColors.text02.swiftUIColor
                ).vPadding(8)
            }
            .padding(24)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        viewStore.selectedGameType == type ? OColors.strokePrimary.swiftUIColor : OColors.stroke02.swiftUIColor,
                        lineWidth: 1.0
                    )
            )
        }
    }
    
    func getImage(_ type: MainSheetFeature.State.AddGameType) -> some View {
        switch type {
        case .add:
            OImages.imgAdd.swiftUIImage
        case .participate:
            OImages.imgSearch.swiftUIImage
        }
    }
    
    func getGameCardTitle(type: MainSheetFeature.State.AddGameType) -> String {
        switch type {
        case .add:
            return "대국 만들기"
        case .participate:
            return "대국 참여하기"
        }
    }
}
