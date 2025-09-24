//
//  HostChangeView.swift
//  GameDetail
//
//  Created by 김동준 on 9/23/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct HostChangeView: View {
    private let store: StoreOf<HostChangeFeature>
    @ObservedObject private var viewStore: ViewStoreOf<HostChangeFeature>
    
    public init(store: StoreOf<HostChangeFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        hostChangeBody
            .onAppear {
                viewStore.send(.onAppear)
            }
    }
    
    private var hostChangeBody: some View {
        VStack(spacing: 0) {
            navigationBar
            
            Spacer()
        }
    }
}

private extension HostChangeView {
    var navigationBar: some View {
        ONavigationBar(
            title: "대국장 변경하기",
            leadingIcon: OImages.icArrowLeft.swiftUIImage,
            leadingIconAction: {
                viewStore.send(.navigateToBack)
            }
        )
    }
}
