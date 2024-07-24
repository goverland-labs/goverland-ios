//
//  DelegateButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class DelegateButtonDataSource: ObservableObject {
    @Published var delegationID: UUID?
    @Published var isUpdating: Bool
    private var cancellables: Set<AnyCancellable>
    private let onDelegateToggle: ((_ didDelegate: Bool) -> Void)?

    init(delegationID: UUID?, onDelegateToggle: ((_ didDelegate: Bool) -> Void)?) {
        self.delegationID = delegationID
        self.onDelegateToggle = onDelegateToggle
        self.isUpdating = false
        self.cancellables = Set<AnyCancellable>()
    }

    func toggle() {
        isUpdating = true 
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if self?.delegationID != nil {
                //unfollowDao()
                self?.onDelegateToggle?(false)
                self?.delegationID = nil
            } else {
                //followDao()
                self?.delegationID = UUID()
                self?.onDelegateToggle?(true)
            }
            self?.isUpdating = false
        }
        
    }
    
//    private func followDao() {
//        isUpdating = true
//        APIService.createSubscription(id: daoId)
//            .sink { [weak self] completion in
//                switch completion {
//                case .finished: break
//                case .failure(_): self?.isUpdating = false
//                }
//            } receiveValue: { [weak self] subscription, headers in
//                guard let `self` = self else { return }
//                self.isUpdating = false
//                self.subscriptionID = subscription.id
//                self.onFollowToggle?(true)
//                NotificationCenter.default.post(name: .subscriptionDidToggle,
//                                                object: (daoId, SubscriptionMeta(id: subscription.id,
//                                                                                 createdAt: subscription.createdAt)))
//                SettingKeys.shared.lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
//            }
//            .store(in: &cancellables)
//    }
    
//    private func unfollowDao() {
//        isUpdating = true
//        APIService.deleteSubscription(id: subscriptionID!)
//            .sink { [weak self] completion in
//                switch completion {
//                case .finished: break
//                case .failure(_): self?.isUpdating = false
//                }
//            } receiveValue: { [weak self] response, headers in
//                guard let `self` = self else { return }
//                self.isUpdating = false
//                self.subscriptionID = nil
//                self.onFollowToggle?(false)
//                NotificationCenter.default.post(name: .subscriptionDidToggle,
//                                                object: (daoId, nil as SubscriptionMeta?))
//            }
//            .store(in: &cancellables)
//    }
}
