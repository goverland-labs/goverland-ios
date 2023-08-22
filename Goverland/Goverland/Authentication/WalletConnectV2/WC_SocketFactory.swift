//
//  WC_SocketFactory.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import Foundation
import Starscream
import WalletConnectRelay

extension WebSocket: WebSocketConnecting { }

struct WC_SocketFactory: WebSocketFactory {
    static let shared = WC_SocketFactory()

    private init() {}

    func create(with url: URL) -> WebSocketConnecting {
        return WebSocket(url: url)
    }
}
