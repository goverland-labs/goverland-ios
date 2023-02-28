//
//  ActivityDetailDividerLineView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-22.
//

import SwiftUI

struct ActivityDetailDividerLineView: View {
    var body: some View {
        Rectangle()
            .fill(Color("lightGrey"))
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
}

struct ActivityDetailDividerLineView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailDividerLineView()
    }
}
