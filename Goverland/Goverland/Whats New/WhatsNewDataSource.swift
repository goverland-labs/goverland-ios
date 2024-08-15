//
//  WhatsNewDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine
import Version

class WhatsNewDataSource {
    var markdown: String {
"""
# 1.1.0

- **Push Notifications:** Added granular control for push notifications related to DAO proposals
- **Inbox Notifications:** Enabled options for archiving proposals in your inbox
- **iPad UX Improvements:** Adjusted the UI of the Home and Profile tabs for wider screens
- **Bug Fixes:** Made several improvements to enhance app stability

![Sample Image](https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png)

# 1.0.0

We are live! 🚀

- **Recommended DAOs**: Discover tailored DAO recommendations after sign-in.
- **Public User Profiles**: See users' governance participation.
- **Top 10 Voters**: See the top voters on proposals and within DAOs.
- **Achievements**: Earn recognition for your contributions.
- **Charts Filtering**: Customize your data visualization experience.
- **Featured Proposals:** Stay informed with highlights.

![Dancing Cat](https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif)

"""
    }

    private var versions: [AppVersion]?
    private var cancellables = Set<AnyCancellable>()

    static let shared = WhatsNewDataSource()

    private init() {}

    func loadData(completion: @escaping (Version) -> Void) {
        APIService.versions()
            .sink { compl in
                // TODO: remove once endpoint is ready
                switch compl {
                case .finished: break
                case .failure(_): completion(Version(1, 1, 1))
                }
            } receiveValue: { [unowned self] versions, headers in
                self.versions = versions
                let latestVersion = versions.sorted { $0.version > $1.version }.first?.version
                completion(latestVersion ?? Version(1, 0, 0))
            }
            .store(in: &cancellables)
    }
}
