//
//  InfoMessageView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct InfoMessageView: View {
    let message: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(Color.textWhite)
                Text(message)
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }
            .padding(.leading, 8)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
        }
        .background {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.containerBright)
        }
    }
}
