//
//  NavigationViewWithToast.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 13.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct NavigationViewWithToast<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack {
            content
        }
        .tint(.textWhite)
        .overlay {
            ToastView()
        }
    }
}
