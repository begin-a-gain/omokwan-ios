//
//  MyGameAddView.swift
//  MyGameAdd
//
//  Created by 김동준 on 11/30/24
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Base

public struct MyGameAddView: View {
    let store: StoreOf<MyGameAddFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyGameAddFeature>
    @FocusState private var focusedField: MyGameAddTextFieldType?
    @FocusState private var passwordFocusedField: PasswordFocusField?
    typealias PasswordFocusField = MyGameAddFeature.State.PasswordFocusField
    
    private enum MyGameAddTextFieldType {
        case gameName
    }

    public init(store: StoreOf<MyGameAddFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        myGameAddBodyView
        .sheet(store: store.scope(state: \.$repeatDaySheet, action: \.repeatDaySheet)) { store in
            MyGameRepeatDaySheetView(store: store)
                .modifier(CommonSheetModifier(detent: [.medium]))
        }
        .sheet(store: store.scope(state: \.$maxPeopleCountSheet, action: \.maxPeopleCountSheet)) { store in
            MaxPeopleCountView(store: store)
                .modifier(CommonSheetModifier(detent: [.medium]))
        }
        .sheet(store: store.scope(state: \.$gameCategorySheet, action: \.gameCategorySheet)) { store in
            MyGameCategorySheetView(store: store)
                .modifier(CommonSheetModifier(detent: [.medium]))
        }
        .oAlert(self.store.scope(state: \.alertState, action: \.alertAction)) {
            Group {
                if let alertCase = viewStore.alertCase {
                    switch alertCase {
                    case .password:
                        passwordAlertView
                    case .create:
                        createAlertView
                    case .leave:
                        leaveAlertView
                    }
                }
            }
        }
    }
    
    private var myGameAddBodyView: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                title: "대국 만들기",
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    viewStore.send(.backButtonTapped)
                }
            )
            Spacer().height(24)
            addGameInfoView
            OButton(
                title: "대국 시작하기",
                status: viewStore.isStartButtonEnable ? .default : .disable,
                type: .default,
                action: {
                    viewStore.send(.gameStartButtonTapped)
                }
            )
            .hPadding(20)
            .vPadding(16)
        }
    }
}

// MARK: info view
private extension MyGameAddView {
    private var addGameInfoView: some View {
        ScrollView {
            VStack(spacing: 0) {
                gameNameSection
                Spacer().height(16)
                defaultSetting
                Spacer().height(24)
                additionalSetting
            }
            .hPadding(20)
        }
    }
    
    private var gameNameSection: some View {
        OTextField<MyGameAddTextFieldType>(
            text: viewStore.$gameName,
            focusedField: $focusedField,
            focusedFieldType: .gameName,
            label: "대국 이름",
            isLabel: true,
            placeholder: "대국 이름을 적어주세요."
        )
    }
}

// MARK: Default Setting
private extension MyGameAddView {
    private var defaultSetting: some View {
        VStack(spacing: 6) {
            OText(
                "기본 설정",
                token: .subtitle_02
            )
            .hPadding(16)
            .greedyWidth(.leading)
            VStack(spacing: 0) {
                repeatDayView
                StrokeDivider(color: OColors.stroke02.swiftUIColor)
                maxNumOfPeopleView
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(OColors.stroke02.swiftUIColor, lineWidth: 1.0))
        }
    }
}

// MARK: Repeat Day
private extension MyGameAddView {
    private var repeatDayView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 8) {
                    OText(
                        "반복 요일",
                        token: .subtitle_03
                    )
                    Spacer()
                    Button {
                        viewStore.send(.repeatDayButtonTapped)
                    } label: {
                        HStack(spacing: 8) {
                            OText(
                                viewStore.selectedRepeatDay.rawValue,
                                token: .subtitle_03,
                                color: OColors.text02.swiftUIColor
                            )
                            OImages.icArrowRight.swiftUIImage.resizedToFit(16,16).vPadding(2)
                        }
                    }
                }
            }
            .padding(16)
            
            if viewStore.selectedRepeatDay == .directSelection {
                dayCircleButtonView
            }
        }
    }
    
    private var dayCircleButtonView: some View {
        HStack(spacing: 0) {
            ForEach(viewStore.directSelectionTypeList.indices, id: \.self) { index in
                Button {
                    viewStore.send(.directSelectionListButtonTapped(index))
                } label: {
                    OText(
                        viewStore.directSelectionTypeList[index].rawValue,
                        token: .subtitle_02,
                        color: viewStore.isSelectedDirectSelectionList[index] ? OColors.textOn01.swiftUIColor : OColors.text02.swiftUIColor
                    )
                    .hPadding(12)
                    .vPadding(10)
                    .background(
                        Circle().fill(viewStore.isSelectedDirectSelectionList[index] ? OColors.uiPrimary.swiftUIColor : OColors.uiBackground.swiftUIColor)
                    )
                    .modifier(DirectSelectionCircleCircleStrokeModifier(viewStore.isSelectedDirectSelectionList[index]))
                }
                if index != viewStore.directSelectionTypeList.count - 1 {
                    Spacer()
                }
            }
        }
        .hPadding(16)
        .padding(.bottom, 16)
    }
    
    private var maxNumOfPeopleView: some View {
        OInputField(
            title: "최대 인원 수",
            value: "\(viewStore.maxNumOfPeople)",
            buttonAction: {
                viewStore.send(.maxNumOfPeopleButtonTapped)
            }
        )
    }
}

// MARK: Additional Setting
private extension MyGameAddView {
    private var additionalSetting: some View {
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
                    isSelected: viewStore.$isRemindAlarmSelected
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
    
    private var gameCategoryView: some View {
        OInputField(
            title: "대국 카테고리",
            value: selectedCategoryString,
            buttonAction: {
                viewStore.send(.gameCategorySettingButtonTapped)
            }
        )
    }
    
    private var selectedCategoryString: String {
        if let category = viewStore.selectedCategory {
            return category.rawValue
        } else {
            return "선택"
        }
    }
}

private struct DirectSelectionCircleCircleStrokeModifier: ViewModifier {
    let isSelected: Bool
    
    init(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func body(content: Content) -> some View {
        if isSelected {
            content
        } else {
            content
                .overlay(
                    Circle()
                        .stroke(OColors.stroke02.swiftUIColor, lineWidth: 1)
                )
        }
    }
}

// MARK: About Alert
private extension MyGameAddView {
    var passwordAlertView: some View {
        OAlertContentView(
            type: .default,
            primaryButtonAction: {
                passwordFocusedField = nil
                viewStore.send(.passwordAlertCancelButtonTapped)
            },
            secondaryButtonAction: {
                viewStore.send(.passwordAlertConfirmButtonTapped)
            },
            content: {
                VStack(spacing: 16) {
                    OText(
                        "대국 코드 설정",
                        token: .headline
                    )
                    HStack(spacing: 8) {
                        MyGameAddPasswordField(
                            text: viewStore.$thousandsPlace,
                            focusedField: $passwordFocusedField,
                            focusedFieldType: .thousandsPlace,
                            refreshAction: { viewStore.send(.passwordRefresh) }
                        )
                        MyGameAddPasswordField(
                            text: viewStore.$hundredsPlace,
                            focusedField: $passwordFocusedField,
                            focusedFieldType: .hundredsPlace,
                            refreshAction: { viewStore.send(.passwordRefresh) }
                        )
                        MyGameAddPasswordField(
                            text: viewStore.$tensPlace,
                            focusedField: $passwordFocusedField,
                            focusedFieldType: .tensPlace,
                            refreshAction: { viewStore.send(.passwordRefresh) }
                        )
                        MyGameAddPasswordField(
                            text: viewStore.$onesPlace,
                            focusedField: $passwordFocusedField,
                            focusedFieldType: .onesPlace,
                            refreshAction: { viewStore.send(.passwordRefresh) }
                        )
                    }
                }.vPadding(4)
            }
        ).onAppear {
            passwordFocusedField = .thousandsPlace
            viewStore.send(.passwordRefresh)
        }
    }
    
    var createAlertView: some View {
        OAlert(
            type: .default,
            title: "대국 생성 하시겠습니까?",
            content: "'\(viewStore.gameName)' 대국을 시작해보세요.",
            primaryButtonAction: {
                viewStore.send(.createAlertCancelButtonTapped)
            },
            secondaryButtonAction: {
                viewStore.send(.createAlertConfirmButtonTapped)
            }
        )
    }
    
    var leaveAlertView: some View {
        OAlert(
            type: .default,
            title: "저장하지 않고 나가시겠습니까?",
            content: """
            모든 입력사항이 사라집니다.
            대국 시작하기를 눌러 저장해주세요.
            """,
            primaryButtonAction: {
                viewStore.send(.leaveAlertCloseButtonTapped)
            },
            secondaryButtonAction: {
                viewStore.send(.leaveAlertLeaveButtonTapped)
            }
        )
    }
}
