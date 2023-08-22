//
//  SignInViewModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 22.08.23.
//

import Foundation
import Combine
import Auth

class SignInViewModel: ObservableObject {
    @Published var state: SigningState = .none

    private var cancelables = Set<AnyCancellable>()

    enum SigningState {
        case none
        case signed(Cacao)
        case error(Error)
    }

    init() {
        setup()
    }

    private func setup() {
        Auth.instance.authResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_, result) in
            switch result {
            case .success(let cacao):
                print("Got signature: \(cacao)")
                self?.state = .signed(cacao)
            case .failure(let error):
                self?.state = .error(error)
            }
        }.store(in: &cancelables)
    }
}
