//
//  SuccessVoteLottieView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import UIKit
import SwiftUI
import Lottie


struct SuccessVoteLottieView: UIViewRepresentable {    
    typealias UIViewType = UIView

    func makeUIView(context: UIViewRepresentableContext<SuccessVoteLottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("vote-success")

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

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SuccessVoteLottieView>) {
        // do nothing
    }
}
