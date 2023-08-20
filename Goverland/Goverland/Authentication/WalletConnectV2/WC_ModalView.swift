//
//  WC_ModalView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import SwiftUI
import WalletConnectPairing
import Web3Modal


struct WC_ModalView: View {
    let metadata = AppMetadata(
        name: "Goverland",
        description: "Mobile App for all DAOs",
        url: "https://goverland.xyz",
        // TODO: provide proper url
        icons: ["https://uploads-ssl.webflow.com/63f0e8f1e5b3e07d58817370/6480451361d81702d7d7ccae_goverland-logo-full.svg"]
    )

    var body: some View {
        ModalContainerView(
            projectId: ConfigurationManager.wcProjectId,
            metadata: metadata,
            webSocketFactory: DefaultSocketFactory.shared
        )
    }
}

struct WC_ModalView_Previews: PreviewProvider {
    static var previews: some View {
        WC_ModalView()
    }
}
