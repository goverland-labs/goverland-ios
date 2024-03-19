//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class FollowButtonDataSource: ObservableObject {
    private let daoId: UUID
    @Published var subscriptionID: UUID?
    @Published var isUpdating: Bool
    private var cancellables: Set<AnyCancellable>
    private let onFollowToggle: ((_ didFollow: Bool, _ daoId: UUID) -> Void)?

    init(daoID: UUID, subscriptionID: UUID?, onFollowToggle: ((_ didFollow: Bool, _ daoId: UUID) -> Void)?) {
        self.daoId = daoID
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
        APIService.createSubscription(id: daoId)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.isUpdating = false
                }
            } receiveValue: { [weak self] subscription, headers in
                guard let `self` = self else { return }
                self.isUpdating = false
                self.subscriptionID = subscription.id
                self.onFollowToggle?(true, daoId)
                NotificationCenter.default.post(name: .subscriptionDidToggle, 
                                                object: (daoId, SubscriptionMeta(id: subscription.id,
                                                                                 createdAt: subscription.createdAt)))
                SettingKeys.shared.lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
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
                self.onFollowToggle?(false, daoId)
                NotificationCenter.default.post(name: .subscriptionDidToggle, 
                                                object: (daoId, nil as SubscriptionMeta?))
            }
            .store(in: &cancellables)
    }
}
