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
        guard let versions = versions?
                // cut off other platforms and versions for not installed releases
            .filter({ $0.platform == .iOS && $0.version <= appVersion })
            .sorted(by: { $0.version > $1.version }), versions.count > 0 else { return "" }
        return versions.reduce("") { r, v in "\(r)# \(v.version)\n\n\(v.markdownDescription)\n\n" }
    }

    var latestVersion: Version {
        versions?
            .filter { $0.platform == .iOS && $0.version <= appVersion }
            .sorted { $0.version > $1.version }.first?.version ?? Version(1, 0, 0)
    }

    let appVersion: Version  = {
        let appVersionStr = Bundle.main.releaseVersionNumber!
        return Version(appVersionStr)!
    }()

    var latestVersionIsAppVerion: Bool {
        latestVersion == appVersion
    }

    private var versions: [AppVersion]?
    private var cancellables = Set<AnyCancellable>()

    static let shared = WhatsNewDataSource()

    private init() {}

    func loadData() {
        APIService.versions()
            .sink { _ in
                // do nothing
            } receiveValue: { [unowned self] versions, _ in
                self.versions = versions
            }
            .store(in: &cancellables)
    }
}
