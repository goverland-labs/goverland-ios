//
//  TooltipViewExtention.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.09.23.
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
        @ViewBuilder tooltipContent: @escaping () -> TooltipContent)
    -> some View {
        modifier(TooltipModifier(enabled: enabled, side: side, tooltipContent: tooltipContent))
    }
}

struct TooltipModifier<TooltipContent: View>: ViewModifier {
    @Binding var enabled: Bool
    let side: TooltipSide
    let tooltipContent: TooltipContent

    init(enabled: Binding<Bool>,
         side: TooltipSide,
         @ViewBuilder tooltipContent: @escaping () -> TooltipContent) {
        self._enabled = enabled
        self.side = side
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
        tooltipConfig.width = 270
        tooltipConfig.arrowHeight = 10
        tooltipConfig.arrowWidth = 10
        tooltipConfig.margin = -4
        return tooltipConfig
    }

    func body(content: Content) -> some View {
        content
            .tooltip(enabled, config: configuration) {
                tooltipContent
            }
    }
}
