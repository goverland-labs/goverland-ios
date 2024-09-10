//
//  GraphHeaderView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct GraphHeaderView: View {
    let header: String
    let subheader: String?

    var body: some View {
        HStack {
            Text(header)
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
            Spacer()
            if let subheader {
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(Color.textWhite40)
                    .padding(.trailing)
                    .onTapGesture() {
                        showInfoAlert(subheader)
                    }
            }
        }
        .padding([.top, .horizontal])
    }
}
