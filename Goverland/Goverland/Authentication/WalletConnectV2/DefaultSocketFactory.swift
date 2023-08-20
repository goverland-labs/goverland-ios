//
//  DefaultSocketFactory.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import Foundation
import Starscream
import WalletConnectRelay

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    static let shared = DefaultSocketFactory()

    private init() {}

    func create(with url: URL) -> WebSocketConnecting {
        return WebSocket(url: url)
    }
}
