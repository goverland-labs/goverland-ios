//
//  LottieView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(animationName)

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

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        // do nothing
    }
}
