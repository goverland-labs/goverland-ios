//
//  ConditionalExtension.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
