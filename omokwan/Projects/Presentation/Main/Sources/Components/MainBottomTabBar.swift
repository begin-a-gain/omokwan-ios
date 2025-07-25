//
//  MainBottomTabBar.swift
//  Main
//
//  Created by 김동준 on 11/10/24
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct MainBottomTabBarView: View {
    @ObservedObject private var viewStore: ViewStoreOf<MainFeature>
    private let hasBottomSafeArea: Bool

    init(viewStore: ViewStoreOf<MainFeature>, hasBottomSafeArea: Bool) {
        self.viewStore = viewStore
        self.hasBottomSafeArea = hasBottomSafeArea
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer().height(MainConstants.circleButtonSize/2)
                tabItems
                Spacer().height(16)
            }
       }
        .height(MainUtil.getBottomTabBarHeight(hasBottomSafeArea))
        .greedyWidth()
    }
    
    private var tabItems: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(MainBottomTabItem.allCases, id: \.self) { item in
                BottomTabItem(
                    selectedTab: viewStore.$selectedTab,
                    item: item,
                    action: {
                        viewStore.send(.selectTab(item))
                    }
                )
            }
        }
    }
}

private struct BottomTabItem: View {
    @Binding var selectedTab : MainBottomTabItem
    let item: MainBottomTabItem
    let action: () -> (Void)
    
    init(
        selectedTab: Binding<MainBottomTabItem>,
        item: MainBottomTabItem,
        action: @escaping () -> Void
    ) {
        self._selectedTab = selectedTab
        self.item = item
        self.action = action
    }
    
    fileprivate var body : some View {
        VStack(spacing: 0) {
            Spacer().height(8)
            Button {
                action()
            } label: {
                VStack(spacing: 0) {
                    getImage(item: item)
                        .renderingMode(.template)
                        .resizedToFit(24, 24)
                        .foregroundColor(item == selectedTab ? OColors.icon01.swiftUIColor : OColors.iconDisable.swiftUIColor)
                    Spacer().height(6)
                    OText(
                        item.rawValue,
                        token: .title_01,
                        color: item == selectedTab ? OColors.text01.swiftUIColor : OColors.textDisable.swiftUIColor
                    )
                }
            }
            Spacer().height(4)
        }
        .vPadding(4)
        .greedyWidth()
    }
    
    private func getImage(item: MainBottomTabItem) -> Image {
        switch item {
        case .myGame:
            OImages.icStone24.swiftUIImage
        case .myPage:
            OImages.icStone24.swiftUIImage
        }
    }
}

public enum MainBottomTabItem: String, CaseIterable {
    case myGame = "My 대국"
    case myPage = "마이페이지"
}
