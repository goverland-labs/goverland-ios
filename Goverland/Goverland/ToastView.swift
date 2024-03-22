//
//  ToastView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine

struct ToastView: View {
    @StateObject var errorViewModel = ToastViewModel.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        // Assure that there is no other view presented on top, otherwise don't show error message here
        if let errorMessage = errorViewModel.errorMessage, activeSheetManager.activeSheet == nil {
            VStack {
                Text(errorMessage)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.textWhite)
                    .foregroundStyle(Color.container)
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation {
                            errorViewModel.setErrorMessage(nil)
                        }
                    }
                Spacer()
            }
            .padding(.horizontal, Constants.horizontalPadding / 2)
            .animation(.easeInOut, value: 1)
            .transition(.move(edge: .top))
        }
    }
}
