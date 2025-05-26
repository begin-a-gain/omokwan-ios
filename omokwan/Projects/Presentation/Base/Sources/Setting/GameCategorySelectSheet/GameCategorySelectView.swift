//
//  GameCategorySelectView.swift
//  Base
//
//  Created by 김동준 on 5/26/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct GameCategorySelectView: View {
    let store: StoreOf<GameCategorySelectFeature>
    @ObservedObject var viewStore: ViewStoreOf<GameCategorySelectFeature>
    
    public init(store: StoreOf<GameCategorySelectFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        OSheetView(
            title: "대국 카테고리",
            sheetContent: sheetContent,
            buttonStatus: viewStore.selectedCategory == nil ? .disable : .default,
            buttonAction: {
                if let category = viewStore.selectedCategory {
                    viewStore.send(.selectButtonTapped(category))
                }
            }
        )
    }
}

private extension GameCategorySelectView {
    var sheetContent: some View {
        DynamicWidthChipsGridView(
            categories: viewStore.categories.map {
                ChipsGridModel(title: $0.rawValue, emoji: $0.emoji)
            },
            selectedTitle: selectedCategory,
            tapAction: { categoryTitle in
                viewStore.send(.categoryTapped(categoryTitle))
            }
        )
        .vPadding(14)
        .hPadding(20)
    }
    
    var selectedCategory: [String]? {
        let nullStringValue = viewStore.selectedCategory?.rawValue
        return nullStringValue.map{ [$0] }
    }
}
