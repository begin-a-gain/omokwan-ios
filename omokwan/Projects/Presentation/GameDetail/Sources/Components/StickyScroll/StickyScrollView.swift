//
//  StickyScrollView.swift
//  GameDetail
//
//  Created by 김동준 on 9/8/25
//

import SwiftUI
import DesignSystem
import Util
import Domain
import UIKit
import ComposableArchitecture

struct StickyScrollView: UIViewControllerRepresentable {
    private let store: StoreOf<StickyCalendarFeature>
    private let availableWidth: CGFloat
    private let hPadding: CGFloat
    
    init(
        store: StoreOf<StickyCalendarFeature>,
        availableWidth: CGFloat,
        hPadding: CGFloat
    ) {
        self.store = store
        self.availableWidth = availableWidth
        self.hPadding = hPadding
    }
    
    func makeUIViewController(context: Context) -> StickyScrollViewController {
        StickyScrollViewController(
            store: store,
            availableWidth: availableWidth,
            hPadding: hPadding
        )
    }
    
    func updateUIViewController(
        _ uiViewController: StickyScrollViewController,
        context: Context
    ) {
        
    }
}
