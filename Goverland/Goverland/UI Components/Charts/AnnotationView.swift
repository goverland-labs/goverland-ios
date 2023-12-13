//
//  AnnotationView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-12-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct AnnotationView: View {
    let firstPlaceholderValue: String
    let firstPlaceholderTitle: String
    let secondPlaceholderValue: String?
    let secondPlaceholderTitle: String?
    let description: String
    
    init(firstPlaceholderValue: String,
         firstPlaceholderTitle: String,
         secondPlaceholderValue: String?,
         secondPlaceholderTitle: String?,
         description: String) {
        self.firstPlaceholderValue = firstPlaceholderValue
        self.firstPlaceholderTitle = firstPlaceholderTitle
        self.secondPlaceholderValue = secondPlaceholderValue
        self.secondPlaceholderTitle = secondPlaceholderTitle
        self.description = description
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(alignment: .bottom, spacing: 4) {
                    Text(firstPlaceholderValue)
                        .font(.title3Regular)
                        .foregroundColor(.textWhite)
                    Text(firstPlaceholderTitle)
                        .font(.subheadlineRegular)
                        .foregroundColor(.textWhite60)
                }
                Spacer()
            }
            
            if let secondPlaceholderValue = secondPlaceholderValue, let secondPlaceholderTitle = secondPlaceholderTitle {
                HStack {
                    HStack(spacing: 4) {
                        Text(secondPlaceholderValue)
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite)
                        Text(secondPlaceholderTitle)
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Text(description)
                        .font(.captionSemibold)
                        .foregroundColor(.textWhite60)
                }
                Spacer()
            }
        }
        .padding(8)
        .background(Color.containerBright)
        .cornerRadius(10)
    }
}
