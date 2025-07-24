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

public struct MainCoordinatorRootView: View {
    private let store: StoreOf<MainCoordinatorFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MainCoordinatorFeature>

    public init(store: StoreOf<MainCoordinatorFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            MainView(store: store.scope(state: \.mainState, action: \.mainAction))
        } destination: { store in
            switch store {
            case .myGame:
                CaseLet(\MainCoordinatorFeature.MainPath.State.myGame, action: MainCoordinatorFeature.MainPath.Action.myGame) { store in
                    MyGameView(store: store)
                }
            case .myGameAdd:
                CaseLet(\MainCoordinatorFeature.MainPath.State.myGameAdd, action: MainCoordinatorFeature.MainPath.Action.myGameAdd) { store in
                    MyGameAddView(store: store)
                }
            case .myGameAddCategory:
                CaseLet(\MainCoordinatorFeature.MainPath.State.myGameAddCategory, action: MainCoordinatorFeature.MainPath.Action.myGameAddCategory) { store in
                    MyGameAddCategoryView(store: store)
                }
            case .myGameParticipate:
                CaseLet(\MainCoordinatorFeature.MainPath.State.myGameParticipate, action: MainCoordinatorFeature.MainPath.Action.myGameParticipate) { store in
                    MyGameParticipateView(store: store)
                }
            case .gameDetail:
                CaseLet(
                    \MainCoordinatorFeature.MainPath.State.gameDetail,
                     action: MainCoordinatorFeature.MainPath.Action.gameDetail
                ) { store in
                    GameDetailView(store: store)
                }
            }
        }
    }
}
