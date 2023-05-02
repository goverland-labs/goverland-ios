//
//  InboxDetailDividerLineView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-22.
//

import SwiftUI

struct InboxDetailDividerLineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
}

struct InboxDetailDividerLineView_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailDividerLineView()
    }
}
