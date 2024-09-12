//
//  DelegationSuccessModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class DelegationSuccessModel: ObservableObject {
    let chainId: Int
    let txHash: String
    @Published var txStatus: TxStatus.Status
    
    init(chainId: Int, txHash: String, txStatus: TxStatus.Status = .pending) {
        self.chainId = chainId
        self.txHash = txHash
        self.txStatus = txStatus
    }
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    func monitor() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            APIService.txStatus(chainId: self.chainId, txHash: self.txHash)
                .sink { _ in
                    // do nothing
                } receiveValue: { [weak self] status, _ in
                    if status.status != .pending {
                        timer.invalidate()
                    }
                    self?.txStatus = status.status
                }
                .store(in: &cancellables)
        }
    }
}
