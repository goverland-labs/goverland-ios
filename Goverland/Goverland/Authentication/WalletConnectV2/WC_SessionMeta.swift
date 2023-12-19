//
//  WC_SessionMeta.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import WalletConnectModal
import SwiftDate

struct WC_SessionMeta: Codable {
    let session: WalletConnectSign.Session
    let walletOnSameDevice: Bool
}

extension WC_SessionMeta {
    var isExpired: Bool {
        return session.expiryDate < .now + 5.minutes
    }

    var walletImage: Image? {
        if let wallet = Wallet.by(name: session.peer.name) {
            return Image(wallet.image)
        }
        return nil
    }

    var walletImageUrl: URL? {
        if let icon = session.peer.icons.first {
            return URL(string: icon)
        }
        return nil
    }
}
