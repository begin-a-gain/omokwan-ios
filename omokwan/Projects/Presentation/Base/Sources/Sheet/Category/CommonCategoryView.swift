//
//  CommonCategoryView.swift
//  Base
//
//  Created by 김동준 on 9/23/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct CommonCategoryView: View {
    private let store: StoreOf<CommonCategoryFeature>
    @ObservedObject private var viewStore: ViewStoreOf<CommonCategoryFeature>
    
    public init(store: StoreOf<CommonCategoryFeature>) {
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
    
    private var sheetContent: some View {
        DynamicWidthChipsGridView(
            categories: viewStore.categories.map {
                ChipsGridModel(title: $0.category, emoji: $0.emoji)
            },
            selectedTitle: selectedCategory,
            tapAction: { categoryTitle in
                viewStore.send(.categoryTapped(categoryTitle))
            }
        )
        .vPadding(14)
        .hPadding(20)
    }
    
    private var selectedCategory: [String]? {
        let nullStringValue = viewStore.selectedCategory?.category
        return nullStringValue.map{ [$0] }
    }
}
