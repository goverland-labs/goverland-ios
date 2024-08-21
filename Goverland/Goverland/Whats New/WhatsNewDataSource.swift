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
            .filter({ $0.platform == .iOS })
            .sorted(by: { $0.version > $1.version }), versions.count > 0 else { return "" }
        return versions.reduce("") { r, v in "\(r)# \(v.version)\n\n\(v.markdownDescription)\n\n" }
    }

    private var versions: [AppVersion]?
    private var cancellables = Set<AnyCancellable>()

    static let shared = WhatsNewDataSource()

    private init() {}

    func loadData(completion: @escaping (Version) -> Void) {
        APIService.versions()
            .sink { _ in
                // do nothing
            } receiveValue: { [unowned self] versions, headers in
                self.versions = versions
                let latestVersion = versions.sorted { $0.version > $1.version }.first?.version
                completion(latestVersion ?? Version(1, 0, 0))
            }
            .store(in: &cancellables)
    }
}
