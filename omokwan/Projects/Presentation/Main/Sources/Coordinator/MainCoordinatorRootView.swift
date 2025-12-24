//
//  MainCoordinatorRootView.swift
//  Main
//
//  Created by 김동준 on 11/20/24
//

import ComposableArchitecture
import SwiftUI
import MyGame
import MyGameAdd
import MyGameParticipate
import GameDetail
import MyPage

public struct MainCoordinatorRootView: View {
    @Bindable private var store: StoreOf<MainCoordinatorFeature>

    public init(store: StoreOf<MainCoordinatorFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.navigationPath, action: \.navigationPath)) {
            MainView(store: store.scope(state: \.mainState, action: \.mainAction))
        } destination: { store in
            switch store.case {
            case .myGame(let store):
                MyGameView(store: store)
            case .myGameAdd(let store):
                MyGameAddView(store: store)
            case .myGameAddCategory(let store):
                MyGameAddCategoryView(store: store)
            case .myGameParticipate(let store):
                MyGameParticipateView(store: store)
            case .gameDetail(let store):
                GameDetailView(store: store)
            case .gameDetailSetting(let store):
                GameDetailSettingView(store: store)
            case .hostChange(let store):
                HostChangeView(store: store)
            case .editNickname(let store):
                EditNicknameView(store: store)
            case .accountDelete(let store):
                AccountDeleteView(store: store)
            }
        }
    }
}
