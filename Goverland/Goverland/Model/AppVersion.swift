//
//  AppVersion.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Version

struct AppVersion: Decodable {
    let version: Version
    let platform: Platform
    let markdownDescription: String

    enum Platform: String, Decodable {
        case iOS
        case Android
        case Web
        case unknown
    }

    enum CodingKeys: String, CodingKey {
        case version
        case platform
        case markdownDescription = "markdown_description"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(Version.self, forKey: .version)
        do {
            self.platform = try container.decode(Platform.self, forKey: .platform)
        } catch {
            self.platform = .unknown
        }
        self.markdownDescription = try container.decode(String.self, forKey: .markdownDescription)
    }
}
