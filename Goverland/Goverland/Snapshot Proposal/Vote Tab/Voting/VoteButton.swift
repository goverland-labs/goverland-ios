//
//  VoteButton.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct VoteButton: View {
    @Binding var disabled: Bool

    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Spacer()
                Text("Vote")
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
            .foregroundColor(disabled ? .textWhite20 : .onPrimary)
            .background(disabled ? Color.disabled12 : Color.primary)
            .font(.footnoteSemibold)
            .cornerRadius(20)
        }
        .disabled(disabled)
    }
}

struct VoteButton_Previews: PreviewProvider {
    static var previews: some View {
        VoteButton(disabled: .constant(false), action: {})
    }
}
