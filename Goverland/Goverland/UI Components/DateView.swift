//
//  DateView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//

import SwiftUI
import SwiftDate

struct DateView: View {
    let date: Date
    let style: RelativeDateTimeFormatter.DateTimeStyle
    let font: Font
    let color: Color

    var body: some View {
        Text(date.toRelative(since: DateInRegion(), dateTimeStyle: style))
            .font(font)
            .lineLimit(1)
            .foregroundColor(color)
    }
}
