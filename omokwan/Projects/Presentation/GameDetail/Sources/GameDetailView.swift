//
//  GameDetailView.swift
//  GameDetail
//
//  Created by 김동준 on 5/12/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct GameDetailView: View {
    let store: StoreOf<GameDetailFeature>
    @ObservedObject var viewStore: ViewStoreOf<GameDetailFeature>
    
    public init(store: StoreOf<GameDetailFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        VStack {
            Text("Game Detail View~")
        }
    }
}
