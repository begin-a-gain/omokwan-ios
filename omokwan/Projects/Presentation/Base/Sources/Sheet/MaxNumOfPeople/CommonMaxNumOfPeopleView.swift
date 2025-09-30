//
//  CommonMaxNumOfPeopleView.swift
//  Base
//
//  Created by 김동준 on 9/22/25
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct CommonMaxNumOfPeopleView: View {
    private let store: StoreOf<CommonMaxNumOfPeopleFeature>
    @ObservedObject private var viewStore: ViewStoreOf<CommonMaxNumOfPeopleFeature>
    
    public init(store: StoreOf<CommonMaxNumOfPeopleFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        OSheetView(
            title: "최대 인원 수",
            sheetContent: sheetContent,
            buttonAction: {
                viewStore.send(.selectButtonTapped(viewStore.selectedMaxNumOfPeopleCount))
            }
        )
    }
    private var sheetContent: some View {
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
