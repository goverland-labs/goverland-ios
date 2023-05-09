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
            .font(.footnoteRegular)
            .lineLimit(1)
            .foregroundColor(.textWhite40)
    }
}
