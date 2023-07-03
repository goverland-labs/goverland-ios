//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import Foundation
import Combine

class FollowButtonDataSource: ObservableObject {
    private let daoID: UUID
    @Published var subscriptionID: UUID?
    @Published var isUpdating: Bool
    private var cancellables: Set<AnyCancellable>
    private let onFollowToggle: ((_ didFollow: Bool) -> Void)?

    init(daoID: UUID, subscriptionID: UUID?, onFollowToggle: ((_ didFollow: Bool) -> Void)?) {
        self.daoID = daoID
        self.subscriptionID = subscriptionID
        self.onFollowToggle = onFollowToggle
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
        APIService.createSubscription(id: daoID)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.isUpdating = false
                }
            } receiveValue: { [weak self] subscription, headers in
                guard let `self` = self else { return }
                self.isUpdating = false
                self.subscriptionID = subscription.id
                self.onFollowToggle?(true)
                NotificationCenter.default.post(name: .subscriptionDidToggle, object: nil)
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
                guard let `self` = self else { return }
                self.isUpdating = false
                self.subscriptionID = nil
                self.onFollowToggle?(false)
                NotificationCenter.default.post(name: .subscriptionDidToggle, object: nil)
            }
            .store(in: &cancellables)
    }
}
