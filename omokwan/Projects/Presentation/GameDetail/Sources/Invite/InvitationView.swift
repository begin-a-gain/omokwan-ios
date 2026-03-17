//
//  InvitationView.swift
//  GameDetail
//
//  Created by jumy on 3/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

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
