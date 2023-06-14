//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import Foundation
import Combine

class FollowButtonDataSource: ObservableObject {
    @Published var isUpdating = false
    private var cancellables = Set<AnyCancellable>()
    var failToFollow: Bool = false
    var failToUnfollow: Bool = false
    
    func followDao(id: UUID) {
        isUpdating = true
        APIService.followDao(id: id)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failToFollow = true
                }
            } receiveValue: { response, headers in
                print("------followDao-------")
                print(response)
                self.isUpdating = false
            }
            .store(in: &cancellables)
    }
    
    func unfollowDao(id: UUID) {
        isUpdating = true
        APIService.unfollowDao(id: id)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failToUnfollow = true
                }
            } receiveValue: { response, headers in
                print("------unfollowDao-------")
                print(response)
                self.isUpdating = false
            }
            .store(in: &cancellables)
    }
}
