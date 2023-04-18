//
//  DateView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//

import SwiftUI
import SwiftDate

struct DateView: View {
    var date: Date

    var body: some View {
        Text(date.toRelative(since: DateInRegion()))
            .font(.system(size: 13))
            .minimumScaleFactor(0.9)
            .lineLimit(1)
            .fontWeight(.medium)
            .foregroundColor(.textWhite40)
    }
}
