//
//  ErrorView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import SwiftUI
import Combine

struct ErrorView: View {
    @StateObject var errorViewModel = ErrorViewModel.shared

    var body: some View {
        if let errorMessage = errorViewModel.errorMessage {
            VStack {
                Text(errorMessage)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.textWhite)
                    .foregroundColor(Color.container)
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
