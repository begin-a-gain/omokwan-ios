//
//  MyGameParticipateCategorySheetView.swift
//  MyGameParticipate
//
//  Created by 김동준 on 2/2/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

struct MyGameParticipateCategorySheetView: View {
    let store: StoreOf<MyGameParticipateCategorySheetFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyGameParticipateCategorySheetFeature>
    
    init(store: StoreOf<MyGameParticipateCategorySheetFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        OSheetView(
            title: "대국 카테고리",
            sheetContent: sheetContent,
            buttonStatus: .default,
            buttonAction: {
                viewStore.send(.sheetConfirmButtonTapped)
            }
        )
    }
    
    private var sheetContent: some View {
        DynamicWidthChipsGridView(
            categories: viewStore.categories.map {
                ChipsGridModel(title: $0.rawValue, emoji: $0.emoji)
            },
            selectedTitle: Array(viewStore.selectedCategoryTitles),
            tapAction: { categoryTitle in
                viewStore.send(.categoryTapped(categoryTitle))
            }
        )
        .vPadding(14)
        .hPadding(20)
    }
}
