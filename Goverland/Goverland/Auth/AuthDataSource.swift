//
//  AuthDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-07.
//

import Foundation
import Combine

class AuthDataSource: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var failedToGetToken: Bool = false
    @Published var token: String = "tokenID"
    private(set) var isEmpty: Bool = true
    
    func getToken() {
        APIService.token()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToGetToken = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.token = result
                self?.isEmpty = false
            }
            .store(in: &cancellables)
    }
}
