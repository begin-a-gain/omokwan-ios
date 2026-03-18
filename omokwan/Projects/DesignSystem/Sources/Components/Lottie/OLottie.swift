//
//  OLottie.swift
//  DesignSystem
//
//  Created by jumy on 3/18/26.
//

import SwiftUI
import Lottie

public struct OLottieView: View {
    private let animation: LottieAnimation?
    private let loopMode: LottieLoopMode
    private let speed: CGFloat
    
    public init(
        _ asset: AnimationAsset,
        loopMode: LottieLoopMode = .loop,
        speed: CGFloat = 1.0
    ) {
        self.animation = asset.animation
        self.loopMode = loopMode
        self.speed = speed
    }
    
    public var body: some View {
        LottieView(animation: animation)
            .configure { animationView in
                animationView.loopMode = loopMode
                animationView.animationSpeed = speed
            }
            .playing()
    }
}
