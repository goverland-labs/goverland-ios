//
//  MarkdownTheme.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.07.23.
//

import MarkdownUI

extension Theme {
    static let goverland = Theme()
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
        }
        .link {
            ForegroundColor(.primaryDim)
        }
        .text {
            ForegroundColor(.textWhite)
            FontFamilyVariant(.normal)
            FontStyle(.normal)
            FontSize(.em(1))
        }
        .paragraph { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: 0, bottom: 16)
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
        }
}
