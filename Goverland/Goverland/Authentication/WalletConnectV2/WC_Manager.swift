//
//  WC_Manager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import Foundation
import WalletConnectNetworking
import WalletConnectPairing
import Auth

class WC_Manager {
    static func configure() {
        Networking.configure(projectId: ConfigurationManager.wcProjectId, socketFactory: WC_SocketFactory.shared)
        Pair.configure(metadata: WC_Goverland.metadata)
        Auth.configure(crypto: WC_CryptoProvider())
    }
}
