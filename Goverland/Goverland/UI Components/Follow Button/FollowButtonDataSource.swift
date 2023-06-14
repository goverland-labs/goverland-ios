//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import Foundation
import Combine

class FollowButtonDataSource: ObservableObject {
    @Published var isFollowing: Bool
    private let daoID: UUID
    @Published var isUpdating: Bool
    private var cancellables: Set<AnyCancellable>

    init(isFollowing: Bool, daoID: UUID) {
        self.isFollowing = isFollowing
        self.daoID = daoID
        self.isUpdating = false
        self.cancellables = Set<AnyCancellable>()
    }

    func toggle() {
        if isFollowing {
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
            } receiveValue: { [weak self] response, headers in
                self?.isUpdating = false
                self?.isFollowing = true
            }
            .store(in: &cancellables)
    }
    
    private func unfollowDao() {
        isUpdating = true
        APIService.unfollowDao(id: daoID)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.isUpdating = false
                }
            } receiveValue: { [weak self] response, headers in
                self?.isUpdating = false
                self?.isFollowing = false
            }
            .store(in: &cancellables)
    }
}
