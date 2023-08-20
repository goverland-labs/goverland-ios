//
//  WalletConnectManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import Foundation
import WalletConnectNetworking

class WalletConnectManager {
    static func configure() {
        Networking.configure(
            projectId: ConfigurationManager.wcProjectId,
            socketFactory: DefaultSocketFactory.shared
        )
    }
}
