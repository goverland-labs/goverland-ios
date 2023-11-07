//
//  Fonts.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-19.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

extension Font {
    static let сaption2Regular = Font.caption2.weight(.regular)
    static let caption2Semibold = Font.caption2.weight(.semibold)
    static let сaptionRegular = Font.caption.weight(.regular)
    static let captionSemibold = Font.caption.weight(.semibold)
    static let footnoteRegular = Font.footnote.weight(.regular)
    static let footnoteSemibold = Font.footnote.weight(.semibold)
    static let subheadlineRegular = Font.subheadline.weight(.regular)
    static let subheadlineSemibold = Font.subheadline.weight(.semibold)
    static let calloutRegular = Font.callout.weight(.regular)
    static let calloutSemibold = Font.callout.weight(.semibold)
    static let bodyRegular = Font.body.weight(.regular)
    static let bodySemibold = Font.body.weight(.semibold)
    static let headlineRegular = Font.headline.weight(.regular)
    static let headlineSemibold = Font.headline.weight(.semibold)
    static let title3Regular = Font.title3.weight(.regular)
    static let title3Semibold = Font.title3.weight(.semibold)
    static let title2Regular = Font.title2.weight(.regular)
    static let title2Semibold = Font.title2.weight(.semibold)
    static let titleRegular = Font.title.weight(.regular)
    static let titleSemibold = Font.title.weight(.semibold)
    static let largeTitleRegular = Font.largeTitle.weight(.regular)
    static let largeTitleSemibold = Font.largeTitle.weight(.semibold)
    
    static func chillaxRegular(size: CGFloat) -> Font {
        return Font.custom("Chillax-Regular", size: size)
    }
    
    static func chillaxMedium(size: CGFloat) -> Font {
        return Font.custom("Chillax-Medium", size: size)
    }
    
    static func chillaxSemibold(size: CGFloat) -> Font {
        return Font.custom("Chillax-Semibold", size: size)
    }
    
    static func chillaxBold(size: CGFloat) -> Font {
        return Font.custom("Chillax-Bold", size: size)
    }
}
