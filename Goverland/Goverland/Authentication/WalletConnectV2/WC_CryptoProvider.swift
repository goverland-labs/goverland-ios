//
//  WC_CryptoProvider.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 22.08.23.
//

import Foundation
import Auth

struct WC_CryptoProvider: CryptoProvider {
    func recoverPubKey(signature: WalletConnectSigner.EthereumSignature, message: Data) throws -> Data {
        // TODO: figure out if we need it
        Data()
    }

    func keccak256(_ data: Data) -> Data {
        // TODO: figure out if we need it
        Data()
    }
}
