//
//  SnapshotVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
//

import SwiftUI

struct SnapshotVotersView: View {
    
    var body: some View {
        VStack {
            ForEach(0..<30) { index in
                Divider()
                    .background(Color.secondaryContainer)
                HStack {
                    IdentityView(user: .test)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.textWhite)
                    Text("For")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.textWhite40)
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            Text("Voters")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(.textWhite)
                            Image(systemName: "text.bubble.fill")
                                .foregroundColor(.secondaryContainer)
                        }
                    }
                }
                .padding(.vertical, 5)
                .font(.footnoteRegular)
            }
        }
    }
}

struct SnapshotVotersView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotVotersView()
    }
}
