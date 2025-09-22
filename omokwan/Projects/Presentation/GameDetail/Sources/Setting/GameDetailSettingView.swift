//
//  GameDetailSettingView.swift
//  GameDetail
//
//  Created by 김동준 on 5/17/25
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Base
import Domain

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
            .onAppear {
                viewStore.send(.onAppear)
            }
            .oLoading(isPresent: viewStore.isLoading)
            .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
            .sheet(store: store.scope(state: \.$maxNumOfPeopleSheet, action: \.maxNumOfPeopleSheet)) { store in
                CommonMaxNumOfPeopleView(store: store)
                    .modifier(CommonSheetModifier(detent: [.medium]))
            }
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
                    maxNumOfPeople: viewStore.maxNumOfPeople,
                    canChangeMaxNumOfPeopleSetting: viewStore.isHost,
                    maxNumOfPeopleButtonAction: {
                        viewStore.send(.maxNumOfPeopleButtonTapped)
                    }
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

private extension GameDetailSettingView {
    var alertView: some View {
        Group {
            if let alertCase = viewStore.alertCase {
                switch alertCase {
                case .error(let error):
                    errorAlertView(error)
                }
            }
        }
    }
    
    func errorAlertView(_ networkError: NetworkError) -> some View {
        CommonErrorAlertView(networkError) {
            viewStore.send(.alertAction(.dismiss))
        }
    }
}
