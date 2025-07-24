//
//  MainView.swift
//  Main
//
//  Created by 김동준 on 10/1/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import MyGame
import Base

public struct MainView: View {
    private let store: StoreOf<MainFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MainFeature>

    public init(store: StoreOf<MainFeature>) {
        self.store = store
        self.viewStore = ViewStore(store) { $0 }
    }
    
    public var body: some View {
        ZStack {
            mainContentView
                .ignoresSafeArea(edges: .bottom)
            
            MainBottomTabBarShape()
                .fill(OColors.oWhite.swiftUIColor)
                .shadow(
                    color: OColors.oPrimary.swiftUIColor.opacity(0.3),
                    radius: 20,
                    x: 0, y: 0
                )
                .height(MainConstants.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)
            
            MainBottomTabBarView(viewStore: viewStore)
                .height(MainConstants.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)
        }.sheet(store: store.scope(state: \.$mainSheet, action: \.mainSheet)) { store in
            MainSheetView(store: store)
                .modifier(CommonSheetModifier(detent: [.medium]))
        }
    }
    
    private var mainContentView: some View {
        WithViewStore(store, observe: \.selectedTab) { currentTab in
            Group {
                switch currentTab.state {
                case .myGame:
                    MyGameView(
                        store: store.scope(state: \.myGameState, action: \.myGameAction)
                    ).padding(.bottom, MainConstants.bottomTabBarHeight)
                case .myPage:
                    ProfileView()
                        .padding(.bottom, MainConstants.bottomTabBarHeight)
                }
            }
        }
    }
}

// TODO: Remove This View
public struct ProfileView: View {
    public var body: some View {
        VStack {
            Text("Profile View")
            Button {
                
            } label: {
                Text("Logout")
            }
        }
    }
}

