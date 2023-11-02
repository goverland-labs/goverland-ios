//
//  EmptyArchiveView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct EmptyArchiveView: View {
    let onClose: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 24) {
                Spacer()
                Image("looped-line")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width / 2)
                Text("There are no arvived events.")
                    .font(.callout)
                    .foregroundColor(.textWhite)
                Spacer()
                PrimaryButton("Close") {
                    onClose()
                }
            }
            // this is needed as on iPad GeometryReader breaks VStack layout
            .frame(width: geometry.size.width - 32)
            .padding([.horizontal, .bottom], 16)
            .onAppear {
                Tracker.track(.screenArchiveEmpty)
            }
        }
    }
}
