//
//  ScreenExtention.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

extension UIScreen {
    static var isSmall: Bool {
        screenHeight <= 667.0
    }
}
