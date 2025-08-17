//
//  MyGameMainContentView.swift
//  MyGame
//
//  Created by 김동준 on 12/7/24
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

struct MyGameMainContentView: View {
    let store: StoreOf<MyGameFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyGameFeature>
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(store: StoreOf<MyGameFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                Spacer().height(8)
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(
                        Array(zip(viewStore.myGameList.indices, viewStore.myGameList)),
                        id: \.0
                    ) { index, item in
                        ZStack {
                            if let item = item {
                                stoneViewWithData(
                                    geometry: geometry,
                                    item: item,
                                    index: index
                                )
                            } else {
                                onlyCrossLineView(geometry: geometry)
                            }
                        }
                    }
                }
            }.hPadding(4)
        }
    }
    
    private func stoneViewWithData(
        geometry: GeometryProxy,
        item: MyGameModel,
        index: Int
    ) -> some View {
        ZStack {
            CrossLineView(
                crossLineSize: geometry.size.width/2,
                circleSize: geometry.size.width/2 - (MyGameConstants.stonePadding * 2),
                strokeColor: OColors.strokePrimary.swiftUIColor.opacity(0.4),
                hasData: true
            )
            
            MyGameStone(
                fullRectSize: geometry.size.width/2,
                stoneSize: geometry.size.width/2 - (MyGameConstants.stonePadding * 2),
                item: item
            )
        }
    }
    
    private func onlyCrossLineView(geometry: GeometryProxy) -> some View {
        CrossLineView(
            crossLineSize: geometry.size.width/2,
            circleSize: geometry.size.width/2 - (MyGameConstants.stonePadding * 2),
            strokeColor: OColors.strokePrimary.swiftUIColor.opacity(0.4),
            hasData: false
        )
    }
}

