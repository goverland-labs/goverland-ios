//
//  SnapshotProposalCreatorIdentityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposalCreatorIdentityView: View {
    var body: some View {
        HStack(spacing: 5) {
            IdentityView(user: .flipside)
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite60)
            Text("by")
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite60)
            IdentityView(user: .test)
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite)
            Spacer()
        }
    }
}

struct SnapshotProposalIdentityView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalCreatorIdentityView()
    }
}
