//
//  SignOutPopoverView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SignOutPopoverView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Text("Do you want to sign out?")
            .font(.title3Semibold)
            .foregroundColor(.textWhite)
            .padding(.top, 20)
        
        Spacer()
        
        HStack(spacing: 16) {
            SecondaryButton("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            PrimaryButton("Sign out") {
                // sign out logic
            }
        }
        .padding(.horizontal)
        
    }
}

struct SignOutPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        SignOutPopoverView()
    }
}
