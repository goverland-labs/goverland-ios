//
//  DeviceOrientationManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

/// Ignore faceUp and faceDown orientations
class DeviceOrientationManager: ObservableObject {
    @Published var currentOrientation: UIDeviceOrientation

    static let shared = DeviceOrientationManager()

    private init() {
        switch UIDevice.current.orientation {
        case .faceUp, .faceDown:
            currentOrientation = .portrait
        default:
            currentOrientation = UIDevice.current.orientation
        }
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func orientationDidChange() {
        switch UIDevice.current.orientation {
        case .faceUp, .faceDown:
            break
        default:
            DispatchQueue.main.async {
                self.currentOrientation = UIDevice.current.orientation
            }
        }
    }
}
