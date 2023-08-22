//
//  SignInViewModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 22.08.23.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    private var cancelables = Set<AnyCancellable>()

    init() {
        setup()
    }

    private func setup() {

    }
}
