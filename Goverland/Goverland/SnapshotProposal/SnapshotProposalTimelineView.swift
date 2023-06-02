//
//  SnapshotProposalTimelineView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposalTimelineView: View {
    private let testDates = [Date.now]
    private let testEvents = ["Snapshot vote created by ", "Discussion started by "]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Timeline")
                .font(.headlineSemibold)
                .foregroundColor(.textWhite)
            
            ForEach(0..<2) { i in
                HStack(spacing: 2) {
                    //DateView(date: Date("Nov 5, 2022") ?? Date.now)
                    Text("Nov 5, 2022 - ")
                    Text(testEvents[i])
                    IdentityView(user: .test)
                }
                .font(.footnoteRegular)
                .foregroundColor(.textWhite)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            }
        }
    }
}

struct SnapshotProposaTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalTimelineView()
    }
}
