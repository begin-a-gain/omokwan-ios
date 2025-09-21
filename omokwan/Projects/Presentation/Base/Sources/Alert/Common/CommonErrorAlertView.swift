//
//  CommonErrorAlertView.swift
//  Base
//
//  Created by 김동준 on 7/26/25
//

import SwiftUI
import DesignSystem
import Domain

public struct CommonErrorAlertView: View {
    private let networkError: NetworkError
    private let primaryButtonAction: () -> Void
    
    public init(
        _ networkError: NetworkError,
        primaryButtonAction: @escaping () -> Void
    ) {
        self.networkError = networkError
        self.primaryButtonAction = primaryButtonAction
    }
    
    public var body: some View {
        OAlert(
            type: .defaultOnlyOK,
            title: networkError.toTitle,
            content: networkError.toContents,
            primaryButtonAction: {
                primaryButtonAction()
            }
        )
    }
}
