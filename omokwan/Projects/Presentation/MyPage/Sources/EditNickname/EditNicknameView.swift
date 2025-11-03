//
//  EditNicknameView.swift
//  MyPage
//
//  Created by 김동준 on 11/3/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct EditNicknameView: View {
    private let store: StoreOf<EditNicknameFeature>
    @ObservedObject private var viewStore: ViewStoreOf<EditNicknameFeature>
    
    public init(store: StoreOf<EditNicknameFeature>) {
        self.store = store
        viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        editNicknameBody
            .onAppear { viewStore.send(.onAppear) }
    }
    
    private var editNicknameBody: some View {
        VStack{}
    }
}
