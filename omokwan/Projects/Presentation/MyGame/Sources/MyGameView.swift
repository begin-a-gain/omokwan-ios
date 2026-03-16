//
//  MyGameView.swift
//  MyGame
//
//  Created by 김동준 on 11/23/24
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Util

public struct MyGameView: View {
    private let store: StoreOf<MyGameFeature>
    @ObservedObject private var viewStore: ViewStoreOf<MyGameFeature>

    public init(store: StoreOf<MyGameFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        myGameViewBody
        .onAppear {
            viewStore.send(.onAppear)
        }
        .sheet(store: store.scope(state: \.$myGameSheet, action: \.myGameSheet)) { store in
            MyGameSheetView(store: store)
                .modifier(CommonSheetModifier(detent: [.medium]))
        }
    }
    
    private var myGameViewBody: some View {
        ZStack(alignment: .bottom) {
            if viewStore.isGameAddFloatingMessageVisible {
                gameAddFloatingMessageView
                    .zIndex(2)
            }
            VStack(spacing: 0) {
                ONavigationBar(
                    isMain: true,
                    trailingIcon: OImages.icBell.swiftUIImage,
                    trailingIconAction: {
                        viewStore.send(.bellButtonTapped)
                    },
                    hasNotification: viewStore.hasNotification
                )
                dateInfoView
                StrokeDivider(color: OColors.stroke01.swiftUIColor)
                MyGameMainContentView(store: store)
            }.zIndex(1)
        }
    }
    
    private var gameAddFloatingMessageView: some View {
        ZStack {
            OText(
                "대국을 생성해보세요!",
                token: .title_01,
                color: OColors.textOn01.swiftUIColor
            )
            .hPadding(28)
            .vPadding(12)
            .background(OColors.uiBackground2.swiftUIColor)
            .cornerRadius(8)
            .padding(.bottom, 60)
            .overlay {
                RoundedTriangle(cornerRadius: 4)
                    .rotation(.degrees(180))
                    .fill(OColors.uiBackground2.swiftUIColor)
                    .overlay {
                        RoundedTriangle(cornerRadius: 4)
                            .rotation(.degrees(180))
                            .stroke(OColors.uiBackground2.swiftUIColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    }
                    .frame(30, 30)
                    .padding(.bottom, 14)
            }
        }
    }
}

// MARK: About Calendar
private extension MyGameView {
    private var dateInfoView: some View {
        HStack(spacing: 8) {
            Button {
                viewStore.send(.dateArrowLeftButtonTapped)
            } label: {
                OImages.icArrowLeft.swiftUIImage
                    .renderingMode(.template)
                    .resizedToFit(20, 20)
                    .foregroundColor(OColors.icon01.swiftUIColor)
            }
            
            Button {
                viewStore.send(.datePickerButtonTapped)
            } label: {
                OText(
                    viewStore.selectedDate.formattedString(),
                    token: .headline,
                    color: OColors.gray900.swiftUIColor
                )
            }
            
            Button {
                viewStore.send(.dateArrowRightButtonTapped)
            } label: {
                OImages.icArrowRight.swiftUIImage
                    .renderingMode(.template)
                    .resizedToFit(20, 20)
                    .foregroundColor(isSelectedDateEqualsToday ? OColors.iconDisable.swiftUIColor : OColors.icon01.swiftUIColor)
            }.disabled(isSelectedDateEqualsToday)
        }.vPadding(16)
    }
    
    private var isSelectedDateEqualsToday: Bool {
        let isDisable = viewStore.selectedDate.formattedString(format: DateFormatConstants.calendarDayDateFormatter) ==
        Date.now.formattedString(format: DateFormatConstants.calendarDayDateFormatter)
        
        return isDisable
    }
}
