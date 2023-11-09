//
//  DeleteProfilePopoverView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DeleteProfilePopoverView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            Text("Are you sure?")
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
            
            Image("settings-partnership-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
                .clipped()
                .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("This profile will no longer be available, and all your saved data will be permanently deleted from all connected devices.")
                
                Text("Deleting your account can’t be undone.")
            }
            .font(.bodyRegular)
            .foregroundColor(.textWhite)
        }
        .padding(.top, 30)
        
        Spacer()
        
        HStack(spacing: 20) {
            SecondaryButton("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            PrimaryButton("Delete") {
                // delete profile logic
            }
        }
        .padding(.horizontal)
        
    }
}

struct DeleteProfilePopoverView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfilePopoverView()
    }
}