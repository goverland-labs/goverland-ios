//
//  Haptic.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

class Haptic {
    private static let impactLight = UIImpactFeedbackGenerator(style: .light)
    private static let impactMed = UIImpactFeedbackGenerator(style: .medium)
    private static let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

    static func light() {
        impactLight.impactOccurred()
    }

    static func medium() {
        impactMed.impactOccurred()
    }

    static func heavy() {
        impactHeavy.impactOccurred()
    }
}
