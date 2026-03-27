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
    @FocusState private var passwordFocusedField: PasswordField?

    private enum GameDetailSettingTextFieldType {
        case gameTitle
    }
    
    public init(store: StoreOf<GameDetailSettingFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            settingBody
                .ignoresSafeArea(edges: .bottom)
                .padding(.bottom, GameDetailConstants.bottomPadding)

            bottomShadowView
                .height(DeviceInfo.shared.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)

            bottomButtonView
                .padding(.bottom, DeviceInfo.shared.homeIndicatorHeight)
                .height(DeviceInfo.shared.bottomTabBarHeight)
                .greedyHeight(.bottom)
                .ignoresSafeArea(edges: .bottom)
        }
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
        .sheet(store: store.scope(state: \.$categorySheet, action: \.categorySheet)) { store in
            CommonCategoryView(store: store)
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
    
    private var bottomShadowView: some View {
        RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
            .fill(OColors.oWhite.swiftUIColor)
            .shadow(
                color: OColors.oPrimary.swiftUIColor.opacity(0.3),
                radius: 20,
                x: 0, y: 0
            )
    }

    var bottomButtonView: some View {
        OButton(
            title: "저장하기",
            status: viewStore.isSaveButtonEnable ? .default : .disable,
            type: .default
        ) {
            viewStore.send(.saveButtonTapped)
        }
        .vPadding(16)
        .hPadding(20)
    }

}

private extension GameDetailSettingView {
    var scrollContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                gameTitleSection
                    .padding(.top, 24)
                
                GameDefaultSettingView(
                    daysInProgress: viewStore.currentConfiguration.daysInProgress,
                    gameCode: viewStore.currentConfiguration.code,
                    dayDescription: viewStore.currentConfiguration.dayDescription,
                    maxNumOfPeople: viewStore.currentConfiguration.maxNumberOfPlayers,
                    canChangeMaxNumOfPeopleSetting: viewStore.isHost,
                    gameCodeButtonAction: {
                        viewStore.send(.gameCodeButtonTapped)
                    },
                    maxNumOfPeopleButtonAction: {
                        viewStore.send(.maxNumOfPeopleButtonTapped)
                    }
                )
                
                GameOhterSettingView(
                    gameCategory: viewStore.selectedCategory,
                    privateRoomPassword: viewStore.currentConfiguration.password,
                    isPrivateRoom: !viewStore.currentConfiguration.isPublic,
                    canChangeSetting: viewStore.isHost,
                    categoryButtonAction: {
                        viewStore.send(.gameCategorySettingButtonTapped)
                    },
                    privateRoomCodeAreaButtonAction: {
                        viewStore.send(.privateRoomCodeButtonTapped)
                    },
                    privateRoomButtonAction: {
                        viewStore.send(.privateRoomButtonAction)
                    }
                )
                
                GameManagementSettingView(
                    isHost: viewStore.isHost,
                    allUserCount: viewStore.gameUserInfos.count,
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
                .padding(.bottom, 24)
            }
        }
        .hPadding(20)
        .scrollIndicators(.hidden)
    }
}

// MARK: Title
private extension GameDetailSettingView {
    var gameTitleSection: some View {
        OTextField<GameDetailSettingTextFieldType>(
            text: viewStore.$gameTitle,
            focusedField: $focusedField,
            focusedFieldType: .gameTitle,
            label: "대국 이름",
            isLabel: true,
            placeholder: "대국 이름을 적어주세요.",
            errorMessage: mappingGameTitleErrorMessage(viewStore.gameTitleValidStatus),
            isDisabled: !viewStore.isHost,
            trailingIcon: viewStore.isHost ? OImages.icCancel.swiftUIImage : nil,
            trailingIconButtonAction: {
                viewStore.send(.binding(.set(\.$gameTitle, "")))
            }
        )
    }
    
    func mappingGameTitleErrorMessage(_ status: GameNameValidStatus?) -> String {
        guard let status = status else { return "" }
        
        return status.errorMessage
    }
}

private extension GameDetailSettingView {
    var alertView: some View {
        Group {
            if let alertCase = viewStore.alertCase {
                switch alertCase {
                case .error(let error):
                    errorAlertView(error)
                case .password:
                    passwordAlertView
                case .exit:
                    exitAlertView
                }
            }
        }
    }
    
    func errorAlertView(_ networkError: NetworkError) -> some View {
        CommonErrorAlertView(networkError) {
            viewStore.send(.alertAction(.dismiss))
        }
    }
    
    var passwordAlertView: some View {
        CommonPasswordAlertView(
            focusedField: $passwordFocusedField,
            thousandsPlaceText: viewStore.$thousandsPlace,
            hundredsPlaceText: viewStore.$hundredsPlace,
            tensPlaceText: viewStore.$tensPlace,
            onesPlaceText: viewStore.$onesPlace,
            primaryButtonAction: { viewStore.send(.alertAction(.dismiss)) },
            secondaryButtonAction: { viewStore.send(.passwordAlertConfirmButtonTapped) }
        )
    }
    
    var exitAlertView: some View {
        OAlert(
            type: .default,
            title: "대국에서 나가시겠어요?",
            content: "대국에 대한 모든 정보가 사라지며 복구할 수 없어요.",
            primaryButtonAction: {
                viewStore.send(.alertAction(.dismiss))
            },
            secondaryButtonTitle: "나가기",
            secondaryButtonBackgroundColor: OColors.uiAlert.swiftUIColor,
            secondaryButtonAction: {
                viewStore.send(.exitAlertButtonTapped)
            }
        )
    }
}
