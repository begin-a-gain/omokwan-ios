//
//  MaxPeopleCountView.swift
//  Base
//
//  Created by 김동준 on 5/26/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct MaxPeopleCountView: View {
    let store: StoreOf<MaxPeopleCountFeature>
    @ObservedObject var viewStore: ViewStoreOf<MaxPeopleCountFeature>
    
    public init(store: StoreOf<MaxPeopleCountFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        OSheetView(
            title: "최대 인원 수",
            sheetContent: sheetContent,
            buttonAction: {
                viewStore.send(
                    .selectButtonTapped(viewStore.selectedMaxNumOfPeopleCount)
                )
            }
        )
    }
}

private extension MaxPeopleCountView {
    var sheetContent: some View {
        Picker("", selection: viewStore.$selectedMaxNumOfPeopleCount) {
            ForEach(viewStore.maxNumOfPeopleAllCases, id: \.self) {
                OText("\($0)")
            }
        }
        .pickerStyle(.wheel)
        .vPadding(14)
        .hPadding(20)
    }
}
