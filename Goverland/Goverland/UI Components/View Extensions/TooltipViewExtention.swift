//
//  TooltipViewExtention.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.09.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftUITooltip

enum TooltipSide {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

extension View {
    func tooltip<TooltipContent: View>(
        _ enabled: Binding<Bool>,
        side: TooltipSide = .bottomLeft,
        width: CGFloat = 270,
        @ViewBuilder tooltipContent: @escaping () -> TooltipContent)
    -> some View {
        modifier(TooltipModifier(enabled: enabled, side: side, width: width, tooltipContent: tooltipContent))
    }
}

fileprivate struct TooltipModifier<TooltipContent: View>: ViewModifier {
    @Binding var enabled: Bool
    let side: TooltipSide
    let width: CGFloat
    let tooltipContent: TooltipContent

    init(enabled: Binding<Bool>,
         side: TooltipSide,
         width: CGFloat,
         @ViewBuilder tooltipContent: () -> TooltipContent) {
        self._enabled = enabled
        self.side = side
        self.width = width
        self.tooltipContent = tooltipContent()
    }

    var tooltipSide: SwiftUITooltip.TooltipSide {
        switch side {
        case .bottomLeft: return .bottomLeft
        case .bottomRight: return .bottomRight
        case .topLeft: return .topLeft
        case .topRight: return .topRight
        }
    }

    var configuration: TooltipConfig {
        var tooltipConfig = DefaultTooltipConfig()
        tooltipConfig.borderColor = Color.clear
        tooltipConfig.backgroundColor = Color.containerBright
        tooltipConfig.borderRadius = 10
        tooltipConfig.contentPaddingLeft = 8
        tooltipConfig.contentPaddingRight = 8
        tooltipConfig.contentPaddingTop = 8
        tooltipConfig.contentPaddingBottom = 8
        tooltipConfig.side = tooltipSide
        tooltipConfig.width = width
        tooltipConfig.arrowHeight = 10
        tooltipConfig.arrowWidth = 10
        tooltipConfig.margin = -4
        tooltipConfig.zIndex = 1_000
        return tooltipConfig
    }

    func body(content: Content) -> some View {
        content
            .tooltip(enabled, config: configuration) {
                tooltipContent
                    .onTapGesture {
                        if enabled {
                            enabled.toggle()
                        }
                    }
            }
    }
}
