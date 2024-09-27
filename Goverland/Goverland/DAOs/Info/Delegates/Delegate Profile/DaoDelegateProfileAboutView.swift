//
//  DaoDelegateProfileAboutView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-13.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileAboutView: View {
    let delegate: Delegate
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("About")
                        .font(.headlineSemibold)
                        .foregroundColor(.textWhite)
                    if !delegate.about.isEmpty {
                        Text(delegate.about)
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)
                    } else {
                        Text("Not provided yet")
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite40)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Statement")
                        .font(.headlineSemibold)
                        .foregroundColor(.textWhite)
                    if !delegate.statement.isEmpty {
                        Text(delegate.statement)
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)
                    } else {
                        Text("Not provided yet")
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite40)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            Tracker.track(.screenDelegateProfileAbout)
        }

        Spacer()
    }
}
