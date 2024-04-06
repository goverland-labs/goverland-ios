//
//  Avatar.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Avatar: Codable {
    let size: Size
    let link: URL

    enum Size: String, Codable {
        case xs
        case s
        case m
        case l
        case xl

        var profileImageSize: CGFloat {
            switch self {
            case .xs: return 16
            case .s: return 26
            case .m: return 46
            case .l: return 76
            case .xl: return 90
            }
        }

        var daoImageSize: CGFloat {
            switch self {
            case .xs: return 16
            case .s: return 32
            case .m: return 46
            case .l: return 76
            case .xl: return 90
            }
        }

        var achievementImageSize: CGSize {
            switch self {
            case .xs, .s: return CGSize(width: 84, height: 100)
            case .m, .l, .xl: return CGSize(width: 320, height: 400)
            }
        }
    }
}
