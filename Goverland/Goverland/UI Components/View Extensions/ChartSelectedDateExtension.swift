//
//  ChartSelectedDateExtension.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Charts

extension View {
    func chartSelected_X_Date(_ selectedDate: Binding<Date?>, minValue: Date, maxValue: Date) -> some View {
        modifier(ChartModifier(selected: selectedDate, minValue: minValue, maxValue: maxValue))
    }

    func chartSelected_X_String(_ selectedString: Binding<String?>) -> some View {
        modifier(ChartModifier(selected: selectedString, minValue: nil, maxValue: nil))
    }
}

fileprivate struct ChartModifier<ValueType: Plottable & Comparable>: ViewModifier {
    @Binding var selected: ValueType?
    let minValue: ValueType?
    let maxValue: ValueType?

    func body(content: Content) -> some View {
        content
            .chartOverlay { chartProxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            SpatialTapGesture()
                                .onEnded { value in
                                    selectFor(x: value.location.x, chartProxy: chartProxy)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        selected = nil
                                    }
                                }
                                .exclusively(
                                    before: DragGesture()
                                        .onChanged { value in
                                            selectFor(x: value.location.x, chartProxy: chartProxy)
                                        }
                                        .onEnded { _ in
                                            selected = nil
                                        }
                                )
                        )
                }
            }
    }

    private func selectFor(x: Double, chartProxy: ChartProxy) {
        let selectedOnGraph = chartProxy.value(atX: x, as: ValueType.self)
        if let minValue, let selectedOnGraph {
            guard selectedOnGraph >= minValue else { selected = nil; return }
        }
        if let maxValue, let selectedOnGraph {
            guard selectedOnGraph <= maxValue else { selected = nil; return }
        }
        selected = selectedOnGraph
    }
}
