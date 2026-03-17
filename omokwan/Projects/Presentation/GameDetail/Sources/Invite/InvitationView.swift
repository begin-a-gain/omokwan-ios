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
    private let store: StoreOf<InvitationFeature>
    
    public init(store: StoreOf<InvitationFeature>) {
        self.store = store
    }
    
    public var body: some View {
        invitationBody
            .background(OColors.uiBackground.swiftUIColor)
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
            
            Spacer()
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
