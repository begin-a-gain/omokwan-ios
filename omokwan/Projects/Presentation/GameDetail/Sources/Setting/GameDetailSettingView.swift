//
//  GameDetailSettingView.swift
//  GameDetail
//
//  Created by 김동준 on 5/17/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

public struct GameDetailSettingView: View {
    let store: StoreOf<GameDetailSettingFeature>
    @ObservedObject var viewStore: ViewStoreOf<GameDetailSettingFeature>
    
    public init(store: StoreOf<GameDetailSettingFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        Text("Game Detail Setting View")
    }
}
