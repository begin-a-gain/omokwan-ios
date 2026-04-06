//
//  MyGameRepeatDaySheetView.swift
//  MyGameAdd
//
//  Created by 김동준 on 12/7/24
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

struct MyGameRepeatDaySheetView: View {
    let store: StoreOf<MyGameRepeatDaySheetFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyGameRepeatDaySheetFeature>
    
    init(store: StoreOf<MyGameRepeatDaySheetFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        OSheetView(
            title: "반복 요일",
            sheetContent: sheetContent,
            buttonAction: {
                viewStore.send(.selectButtonTapped(viewStore.selectedRepeatDay))
            }
        )
    }
    
    private var sheetContent: some View {
        Picker("", selection: viewStore.$selectedRepeatDay) {
            ForEach(viewStore.repeatDayAllCases, id: \.self) {
                OText($0.rawValue)
            }
        }
        .pickerStyle(.wheel)
        .vPadding(14)
        .hPadding(20)
    }
}
