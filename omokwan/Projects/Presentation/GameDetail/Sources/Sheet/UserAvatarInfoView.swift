//
//  UserAvatarInfoView.swift
//  GameDetail
//
//  Created by 김동준 on 9/15/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

struct UserAvatarInfoView: View {
    private let store: StoreOf<UserAvatarInfoFeature>
    @ObservedObject private var viewStore: ViewStoreOf<UserAvatarInfoFeature>
    
    init(store: StoreOf<UserAvatarInfoFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        Text("User Info ~ ")
    }
}
