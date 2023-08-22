//
//  WC_Manager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import Foundation
import WalletConnectNetworking
import WalletConnectModal

class WC_Manager {
    static func configure() {
        Networking.configure(projectId: ConfigurationManager.wcProjectId, socketFactory: WC_SocketFactory.shared)
        WalletConnectModal.configure(projectId: ConfigurationManager.wcProjectId, metadata: WC_Goverland.metadata)

//        Pair.configure(metadata: WC_Goverland.metadata)
    }
}
