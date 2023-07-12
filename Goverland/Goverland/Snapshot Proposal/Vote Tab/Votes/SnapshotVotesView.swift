//
//  SnapshotVotesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
//

import SwiftUI

struct SnapshotVotesView: View {
    let proposal: Proposal
    @StateObject var dataSource: SnapsotVotesDataSource
    
    init(proposal: Proposal) {
        _dataSource = StateObject(wrappedValue: SnapsotVotesDataSource(proposal: proposal))
        self.proposal = proposal
    }
    
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
        .onAppear() {
            dataSource.refresh()
        }
    }
}

struct SnapshotVotersView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotVotesView(proposal: .aaveTest)
    }
}
