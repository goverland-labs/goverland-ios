//
//  RefreshIcon.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct RefreshIcon: View {
    let onRefresh: () -> Void

    var body: some View {
        Image(systemName: "arrow.clockwise")
            .padding(.vertical, 16)
            .font(.system(size: 24))
            .foregroundStyle(Color.textWhite)
            .onTapGesture {
                onRefresh()
            }
    }
}
