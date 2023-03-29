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
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation {
                            errorViewModel.errorMessage = nil
                        }
                    }
                Spacer()
            }
            .padding(.horizontal)
            .animation(.easeInOut, value: 1)
            .transition(.move(edge: .top))
        }
    }
}
