//
//  ToolbarTitle.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ToolbarTitle: ToolbarContent {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text(title)
                    .font(.title3Semibold)
                    .foregroundStyle(Color.textWhite)
            }
        }
    }
}
