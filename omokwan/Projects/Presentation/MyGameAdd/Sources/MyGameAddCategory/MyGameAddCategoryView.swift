//
//  MyGameAddCategoryView.swift
//  MyGameAdd
//
//  Created by 김동준 on 11/30/24
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Domain
import Base

public struct MyGameAddCategoryView: View {
    let store: StoreOf<MyGameAddCategoryFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyGameAddCategoryFeature>

    public init(store: StoreOf<MyGameAddCategoryFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        myGameAddCategoryBodyView
        .onAppear {
            viewStore.send(.onAppear)
        }
        .oLoading(isPresent: viewStore.isLoading)
        .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
            alertView
        }
    }
    
    private var myGameAddCategoryBodyView: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    viewStore.send(.navigateToBack)
                }
            )
            Spacer().height(32)
            categoryInfoView
            Spacer().height(32)
            categoriesChipsView
            Spacer()
            buttonView
        }
    }
    
    private var categoryInfoView: some View {
        VStack(spacing: 16) {
            OText(
                "어떤 대국인가요?",
                token: .display
            ).greedyWidth(.leading)
            OText(
                "원하는 카테고리가 없다면 건너뛸 수 있어요!",
                token: .body_long_02,
                color: OColors.text02.swiftUIColor
            ).greedyWidth(.leading)
        }.hPadding(20)
    }
    
    private var categoriesChipsView: some View {
        DynamicWidthChipsGridView(
            categories: viewStore.categories.map {
                ChipsGridModel(title: $0.category, emoji: $0.emoji)
            },
            selectedTitle: selectedCategory,
            tapAction: { categoryTitle in
                viewStore.send(.categoryTapped(categoryTitle))
            }
        )
        .hPadding(20)
    }
    
    private var buttonView: some View {
        VStack(spacing: 16) {
            OButton(
                title: "건너뛰기",
                status: .default,
                type: .text,
                size: .small,
                action: {
                    viewStore.send(.skipButtonTapped(viewStore.categories))
                }
            )
            OButton(
                title: "다음",
                status: viewStore.isNextButtonEnable ? .default : .disable,
                type: .default,
                action: {
                    viewStore.send(.nextButtonTapped(viewStore.categories, viewStore.selectedCategory))
                }
            )
        }
        .padding(.bottom, 16)
        .hPadding(20)
    }
    
    private var selectedCategory: [String]? {
        let nullStringValue = viewStore.selectedCategory?.category
        return nullStringValue.map{ [$0] }
    }
}

// MARK: About Alert
private extension MyGameAddCategoryView {
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
