//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import Foundation
import Combine

class FollowButtonDataSource: ObservableObject {
    @Published var subscriptionID: UUID?
    private let daoID: UUID
    @Published var isUpdating: Bool
    private var cancellables: Set<AnyCancellable>

    init(daoID: UUID, subscriptionID: UUID?) {
        self.daoID = daoID
        self.subscriptionID = subscriptionID
        self.isUpdating = false
        self.cancellables = Set<AnyCancellable>()
    }

    func toggle() {
        if subscriptionID != nil {
            unfollowDao()
        } else {
            followDao()
        }
    }
    
    private func followDao() {
        isUpdating = true
        APIService.followDao(id: daoID)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.isUpdating = false
                }
            } receiveValue: { [weak self] subscription, headers in
                self?.isUpdating = false
                self?.subscriptionID = subscription.id
            }
            .store(in: &cancellables)
    }
    
    private func unfollowDao() {
        isUpdating = true
        APIService.deleteSubscription(id: subscriptionID!)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.isUpdating = false
                }
            } receiveValue: { [weak self] response, headers in
                self?.isUpdating = false
                self?.subscriptionID = nil
            }
            .store(in: &cancellables)
    }
}