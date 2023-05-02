//
//  SnapshotProposaStatusBarView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposaStatusBarView: View {
    var body: some View {
        HStack {
            ProposalStatusView(status: .activeVote)
            Spacer()
            HStack {
                DateView(date: .now)
                    .font(.footnoteRegular)
                    .foregroundColor(.primaryDim)
                Text("left to vote via Snapshot")
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite)
            }
        }
        .padding(10)
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}

struct SnapshotProposaStatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposaStatusBarView()
    }
}
