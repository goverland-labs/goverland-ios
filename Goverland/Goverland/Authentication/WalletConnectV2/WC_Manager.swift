//
//  WC_Manager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import Foundation
import Combine
import WalletConnectNetworking
import WalletConnectModal

class WC_Manager {
    static let shared = WC_Manager()

    private let metadata = AppMetadata(
        name: "Goverland",
        description: "Mobile App for all DAOs",
        url: "https://goverland.xyz",
        // TODO: provide proper url
        icons: ["https://uploads-ssl.webflow.com/63f0e8f1e5b3e07d58817370/6480451361d81702d7d7ccae_goverland-logo-full.svg"]
    )

    static func showModal() {
        WalletConnectModal.present()
    }

    private var cancelables = Set<AnyCancellable>()

    private init() {
        configure()
        listen()
    }

    private func configure() {
        Networking.configure(projectId: ConfigurationManager.wcProjectId, socketFactory: WC_SocketFactory.shared)
        WalletConnectModal.configure(projectId: ConfigurationManager.wcProjectId, metadata: metadata)
    }

    private func listen() {
        Sign.instance.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { session in
                print("Sessions: \(session)")
            }
            .store(in: &cancelables)

        Sign.instance.sessionSettlePublisher
            .receive(on: DispatchQueue.main)
            .sink { session in
                print("Session settle: \(session)")
            }
            .store(in: &cancelables)

        Sign.instance.sessionDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { (str, reason) in
                print("Session deleted: String: \(str); Reason: \(reason)")
            }
            .store(in: &cancelables)
    }
}
