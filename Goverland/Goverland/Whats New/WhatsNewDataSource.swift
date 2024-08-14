//
//  WhatsNewDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class WhatsNewDataSource {
    private var cancellables = Set<AnyCancellable>()

    func loadData(completion: @escaping (String) -> Void) {
        // TODO: imple. skip errors display for this endpoint
        APIService.versions()
            .sink { compl in
                // TODO: remove once endpoint is ready
                switch compl {
                case .finished: break
                case .failure(_): completion(Self.mockMarkdown())
                }
            } receiveValue: { versions, headers in
                completion(Self.markdown(versions: versions))
            }
            .store(in: &cancellables)
    }

    private static func markdown(versions: [AppVersion]) -> String {
        return ""
    }

    // TODO: remove
    private static func mockMarkdown() -> String {
        """
# 1.1.0

Test text goes **here**

# 1.0.0

We are live! 🚀
"""
    }
}
