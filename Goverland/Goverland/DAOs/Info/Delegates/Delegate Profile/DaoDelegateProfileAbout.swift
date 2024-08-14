//
//  DaoDelegateProfileAbout.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-13.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileAbout: View {
    let delegate: Delegate
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("About")
                        .font(.headlineSemibold)
                        .foregroundColor(.textWhite)
                    if let about = delegate.about {
                        Text(about)
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
                    Text(delegate.statement)
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                }
            }
            Spacer()
        }
        .padding()
    }
}
