//
//  WC_QRView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//

import SwiftUI

struct WC_QRView: View {
    @StateObject private var model = QRViewModel()

    var body: some View {
        Text("Hello, World!")
    }
}

fileprivate class QRViewModel: ObservableObject {
    @Published private(set) var loading = false
}

struct WC_QRView_Previews: PreviewProvider {
    static var previews: some View {
        WC_QRView()
    }
}
