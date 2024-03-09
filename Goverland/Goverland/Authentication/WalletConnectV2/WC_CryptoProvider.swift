//
//  WC_CryptoProvider.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	
import WalletConnectModal
import Foundation

struct MockCryptoProvider: CryptoProvider {
    public func recoverPubKey(signature: EthereumSignature, message: Data) throws -> Data {
        Data()
    }

    public func keccak256(_ data: Data) -> Data {
        Data()
    }
}
