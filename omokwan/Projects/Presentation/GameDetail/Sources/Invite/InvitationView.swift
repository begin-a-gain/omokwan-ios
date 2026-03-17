//
//  InvitationView.swift
//  GameDetail
//
//  Created by jumy on 3/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Base

public struct InvitationView: View {
    @Bindable private var store: StoreOf<InvitationFeature>
    
    public init(store: StoreOf<InvitationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        invitationBody
            .background(OColors.ui02.swiftUIColor)
            .onAppear {
                store.send(.onAppear)
            }
            .oLoading(isPresent: store.isLoading)
            .oAlert(store.scope(state: \.alertState, action: \.alertAction)) {
                alertView
            }
    }
    
    private var invitationBody: some View {
        VStack(spacing: 0) {
            ONavigationBar(
                title: "대국 초대하기",
                leadingIcon: OImages.icArrowLeft.swiftUIImage,
                leadingIconAction: {
                    store.send(.navigateToBack)
                }
            )
            searchView
                .hPadding(20)
                .vPadding(16)
                .background(OColors.uiBackground.swiftUIColor)

            Spacer()
        }
    }
}

private extension InvitationView {
    var searchView: some View {
        HStack(spacing: 0) {
            OImages.icSearch.swiftUIImage
                .renderingMode(.template)
                .resizedToFit(20,20)
                .foregroundStyle(OColors.icon02.swiftUIColor)
                .padding(.trailing, 4)
                        
            TextField(
                "이름으로 검색하기",
                text: $store.searchText
            )
            .multilineTextAlignment(.leading)
            .font(.suit(token: .body_01))
            .foregroundStyle(OColors.text01.swiftUIColor)
            .greedyWidth(.leading)
            
            if !store.searchText.isEmpty {
                clearButtonView
            }
        }
        .vPadding(8)
        .hPadding(12)
        .background(OColors.ui03.swiftUIColor)
        .cornerRadius(8)
    }
    
    var clearButtonView: some View {
        HStack(spacing: 0) {
            Spacer().width(12)
            
            Button {
                store.send(.set(\.searchText, ""))
            } label: {
                OImages.icCancel.swiftUIImage
                    .renderingMode(.template)
                    .resizedToFit(20, 20)
                    .foregroundStyle(OColors.icon01.swiftUIColor)
            }
        }
    }
}

private extension InvitationView {
    var alertView: some View {
        Group {
            if let alertCase = store.alertCase {
                switch alertCase {
                case .error(let networkError):
                    CommonErrorAlertView(networkError) {
                        store.send(.alertAction(.dismiss))
                    }
                }
            }
        }
    }
}
