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

    var body: some View {
        if let errorMessage = errorViewModel.errorMessage {
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
            .padding(.horizontal, 8)
            .animation(.easeInOut, value: 1)
            .transition(.move(edge: .top))
        }
    }
}
