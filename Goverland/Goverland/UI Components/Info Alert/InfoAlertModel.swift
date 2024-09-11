//
//  InfoAlertModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class InfoAlertModel: ObservableObject {
    @Published private(set) var alertMarkdownMessage: String?

    static let shared = InfoAlertModel()

    private init() {}

    func setAllertMarkdownMessage(_ message: String?) {
        alertMarkdownMessage = message
    }
}
