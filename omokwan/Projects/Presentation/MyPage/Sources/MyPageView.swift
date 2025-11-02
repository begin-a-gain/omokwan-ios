//
//  MyPageView.swift
//  MyPage
//
//  Created by 김동준 on 11/2/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct MyPageView: View {
    private let store: StoreOf<MyPageFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MyPageFeature>
    
    public init(store: StoreOf<MyPageFeature>) {
        self.store = store
        viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        myPageBody
            .onAppear { viewStore.send(.onAppear) }
    }
    
    private var myPageBody: some View {
        VStack(spacing: 0) {
            ScrollView {
                Text("This is MyPage~~")
            }
        }
    }
}
