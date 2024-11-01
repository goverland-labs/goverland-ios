//
//  LottieIntroView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-22.
//  Copyright © Goverland Inc. All rights reserved.
//

import Lottie
import SwiftUI
import UIKit

struct LottieIntroView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: UIViewRepresentableContext<LottieIntroView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            animationView.animation = LottieAnimation.named("main-intro")
        default:
            animationView.animation = LottieAnimation.named("main-intro-ipad")
        }

        let mode = UIDevice.current.orientation.isPortrait ? UIView.ContentMode.scaleAspectFill : .scaleAspectFit
        animationView.contentMode = mode

        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieIntroView>) {
        // do nothing
    }
}
