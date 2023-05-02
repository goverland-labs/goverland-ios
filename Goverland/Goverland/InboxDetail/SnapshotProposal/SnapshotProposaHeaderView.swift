//
//  SnapshotProposaHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposaHeaderView: View {
    var body: some View {
        Text("GIP-77 (part 1): Should the GnosisDAO add moderators to reduce spam")
            .font(.title3Semibold)
            .foregroundColor(.textWhite)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.7)
    }
}

struct SnapshotProposaHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposaHeaderView()
    }
}
