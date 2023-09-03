//
//  WC_QRView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//

import SwiftUI

struct WC_QRView: View {
    @Binding var showQR: Bool
    @StateObject private var model = QRViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(.black.opacity(0.2))
                .onTapGesture {
                    showQR = false
                }

            Rectangle()
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, maxHeight: 350)
                .mask(TopRoundedCornerShape(radius: 20))
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                showQR = false
                            } label: {
                                // TODO: Fix in other places
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 26))
                            }
                        }
                        .padding(16)

                        Spacer()
                    }
                )
        }
    }
}

fileprivate class QRViewModel: ObservableObject {
    @Published private(set) var loading = false
}

struct WC_QRView_Previews: PreviewProvider {
    static var previews: some View {
        WC_QRView(showQR: .constant(true))
    }
}
