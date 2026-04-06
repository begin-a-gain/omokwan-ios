//
//  Image+Extension.swift
//  DesignSystem
//
//  Created by 김동준 on 10/1/24
//

import SwiftUI

public typealias OImages = DesignSystemAsset.Images

public extension Image {
    func resizedToFit(capInsets: EdgeInsets = EdgeInsets()) -> some View {
        resizable(capInsets: capInsets)
            .scaledToFit()
    }
    
    func resizedToFit(_ width: CGFloat, _ height: CGFloat, _ alignment: Alignment = .center, capInsets: EdgeInsets = EdgeInsets()) -> some View {
        resizedToFit(capInsets: capInsets)
            .frame(width: width, height: height, alignment: alignment)
    }
}
