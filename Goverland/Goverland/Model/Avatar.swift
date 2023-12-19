//
//  Avatar.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Avatar: Codable {
    let size: AvatarSize
    let link: URL

    enum AvatarSize: String, Codable {
        case xs
        case s
        case m
        case l
        case xl

        var imageSize: CGFloat {
            switch self {
            case .xs: return 16
            case .s: return 26
            case .m: return 46
            case .l: return 76
            case .xl: return 90
            }
        }
    }
}
