//
//  DeviceOrientationManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

class DeviceOrientationManager: ObservableObject {
    @Published var currentOrientation: UIDeviceOrientation = UIDevice.current.orientation

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func orientationDidChange() {
        DispatchQueue.main.async {
            self.currentOrientation = UIDevice.current.orientation
        }
    }
}
