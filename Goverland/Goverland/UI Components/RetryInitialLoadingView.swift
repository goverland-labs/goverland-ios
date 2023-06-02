//
//  RetryInitialLoadingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.06.23.
//

import SwiftUI

protocol Refreshable: AnyObject {
    func refresh()
}

// TODO: implement design
struct RetryInitialLoadingView: View {
    let dataSource: Refreshable

    var body: some View {
        Text("Sorry, we couldn’t load the data. Please try again.")
        Button("Try again") {
            dataSource.refresh()
        }
    }
}
