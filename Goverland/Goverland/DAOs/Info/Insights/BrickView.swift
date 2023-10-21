//
//  BrickView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-20.
//

import SwiftUI

struct BrickView: View {
    let title: String
    let subTitle: String
    let data: String
    let metaData: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.footnoteRegular)
                Spacer()
                Image(systemName: "questionmark.circle")
            }
            .foregroundStyle(Color.textWhite60)
            
            Text(data)
                .font(.largeTitleRegular)
                .foregroundStyle(Color.textWhite)
            Text(metaData)
                .font(.subheadlineRegular)
                .foregroundStyle(Color.textWhite60)
        }
        .padding()
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}

#Preview {
    BrickView(title: "", subTitle: "", data: "", metaData: "")
}
