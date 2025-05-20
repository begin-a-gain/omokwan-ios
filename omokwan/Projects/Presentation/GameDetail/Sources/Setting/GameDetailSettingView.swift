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
            VStack(spacing: 0) {
                gameNameSection
                    .padding(.bottom, 24)
                
                defaultSetting
                    .padding(.bottom, 24)
                
                otherSetting
                    .padding(.bottom, 24)
                
                gameManagementView
                    .padding(.bottom, 24)
                
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

// MARK: Default Settings
private extension GameDetailSettingView {
    var defaultSetting: some View {
        VStack(spacing: 6) {
            OText(
                "기본 설정",
                token: .subtitle_02
            )
            .hPadding(16)
            .greedyWidth(.leading)
            VStack(spacing: 0) {
                gameDaysElapsedView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                gameCodeView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                repeatDayView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                maxNumOfPeopleView
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
    
    var gameDaysElapsedView: some View {
        HStack(spacing: 0) {
            OText(
                "대국 진행 일 수",
                token: .subtitle_03
            )
            Spacer()
            OText(
                "+123일 째",
                token: .subtitle_03,
                color: OColors.text02.swiftUIColor
            )
        }
        .padding(16)
    }
    
    var gameCodeView: some View {
        HStack(spacing: 0) {
            OText(
                "대국코드",
                token: .subtitle_03
            )
            Spacer()
            Button {
                UIPasteboard.general.string = "XALXBB6ZU2"
            } label: {
                OText(
                    "XALXBB6ZU2",
                    token: .subtitle_03,
                    color: OColors.text02.swiftUIColor,
                    isUnderline: true
                )
            }
        }
        .padding(16)
    }
    
    var repeatDayView: some View {
        HStack(spacing: 0) {
            OText(
                "반복 요일",
                token: .subtitle_03
            )
            Spacer()
            OText(
                "월, 수, 금",
                token: .subtitle_03,
                color: OColors.text02.swiftUIColor
            )
        }
        .padding(16)
    }
    
    var maxNumOfPeopleView: some View {
        OInputField(
            title: "최대 인원 수",
            value: "\(viewStore.maxNumOfPeople)",
            buttonAction: {
                viewStore.send(.maxNumOfPeopleButtonTapped)
            }
        )
    }
}

// MARK: Other Settings
private extension GameDetailSettingView {
    var otherSetting: some View {
        VStack(spacing: 6) {
            OText(
                "기타 설정",
                token: .subtitle_02
            )
            .hPadding(16)
            .greedyWidth(.leading)
            VStack(spacing: 0) {
                gameCategoryView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                OInputToggleField(
                    title: "리마인드 알림",
                    additionalInfo: "오전 9:00",
                    isSelected: .constant(false)
                )
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                OInputToggleField(
                    title: "비공개",
                    selectAreaAction: {
                        viewStore.send(.privateRoomCodeButtonTapped)
                    },
                    additionalInfo: "코드 : \(viewStore.privateRoomPassword ?? "-")",
                    isSelected: Binding(
                        get: { viewStore.isPrivateRoomSelected },
                        set: { newValue in
                            viewStore.send(.privateRoomToggleButtonTapped)
                        }
                    )
                )

            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
    
    var gameCategoryView: some View {
        OInputField(
            title: "대국 카테고리",
            value: selectedCategoryString,
            buttonAction: {
                viewStore.send(.gameCategorySettingButtonTapped)
            }
        )
    }

    var selectedCategoryString: String {
        if let category = viewStore.selectedCategory {
            return category.rawValue
        } else {
            return "선택"
        }
    }
}

// MARK: Game Management
private extension GameDetailSettingView {
    var gameManagementView: some View {
        VStack(spacing: 6) {
            OText(
                "대국 관리",
                token: .subtitle_02
            )
            .hPadding(16)
            .greedyWidth(.leading)
            VStack(spacing: 0) {
                if viewStore.isHost {
                    inviteView
                    StrokeDivider(color: OColors.stroke02.swiftUIColor)
                }
                gameHostChangeView
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
    
    var inviteView: some View {
        OInputField(
            title: "초대하기",
            buttonAction: {
                viewStore.send(.inviteButtonTapped)
            }
        )
    }
    
    var gameHostChangeView: some View {
        OInputField(
            title: "대국장 변경하기",
            buttonAction: {
                viewStore.send(.hostChangeButtonTapped)
            }
        )
    }
}
