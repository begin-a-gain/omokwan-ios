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
    private let store: StoreOf<GameDetailSettingFeature>
    @ObservedObject private var viewStore: ViewStoreOf<GameDetailSettingFeature>
    @FocusState private var focusedField: GameDetailSettingTextFieldType?

    private enum GameDetailSettingTextFieldType {
        case gameName
    }
    
    public init(store: StoreOf<GameDetailSettingFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        settingBody
    }
    
    private var settingBody: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                title: "대국 설정",
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    viewStore.send(.navigateToBack)
                }
            )
            scrollContent
        }
    }
}

private extension GameDetailSettingView {
    var scrollContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                gameNameSection
                
                GameDefaultSettingView(
                    maxNumOfPeople: viewStore.maxNumOfPeople
                )
                GameOhterSettingView(
                    gameCategory: viewStore.selectedCategory,
                    privateRoomPassword: viewStore.privateRoomPassword,
                    isPrivateRoomSelected: viewStore.isPrivateRoomSelected,
                    categoryButtonAction: {
                        viewStore.send(.gameCategorySettingButtonTapped)
                    },
                    privateRoomCodeAreaButtonAction: {
                        viewStore.send(.privateRoomCodeButtonTapped)
                    },
                    privateRoomToggleButtonAction: {
                        viewStore.send(.privateRoomToggleButtonTapped)
                    }
                )
                
                GameManagementSettingView(
                    isHost: viewStore.isHost,
                    inviteButtonAction: {
                        viewStore.send(.inviteButtonTapped)
                    },
                    hostChangeButtonAction: {
                        viewStore.send(.hostChangeButtonTapped)
                    }
                )
                
                OButton(
                    title: "대국 나가기",
                    status: .error,
                    type: .default
                ) {
                    viewStore.send(.exitButtonTapped)
                }
            }
        }
        .hPadding(20)
        .vPadding(24)
        .scrollIndicators(.hidden)
    }
}

// MARK: Title
private extension GameDetailSettingView {
    var gameNameSection: some View {
        OTextField<GameDetailSettingTextFieldType>(
            text: viewStore.$gameName,
            focusedField: $focusedField,
            focusedFieldType: .gameName,
            label: "대국 이름",
            isLabel: true,
            placeholder: "대국 이름을 적어주세요."
        )
    }
}
