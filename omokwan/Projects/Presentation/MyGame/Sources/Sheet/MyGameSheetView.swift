//
//  MyGameSheetView.swift
//  MyGame
//
//  Created by 김동준 on 12/15/24
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

struct MyGameSheetView: View {
    let store: StoreOf<MyGameSheetFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyGameSheetFeature>
    
    init(store: StoreOf<MyGameSheetFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        OSheetView(
            title: "날짜 선택",
            sheetContent: sheetContent,
            buttonStatus: viewStore.selectedDate <= Date() ? .default : .disable,
            buttonAction: {
                viewStore.send(.selectButtonTapped)
            }
        )
    }
    
    private var sheetContent: some View {
        DatePicker(
            "",
            selection: viewStore.$selectedDate,
            in: ...Date(),
            displayedComponents: [.date]
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .environment(\.locale, Locale(identifier: "ko_KR"))
        .vPadding(34)
    }
}
