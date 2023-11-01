//
//  ChartSelectedDateExtension.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.11.23.
//

import SwiftUI
import Charts

extension View {
    func chartSelected_X_Date(_ selectedDate: Binding<Date?>) -> some View {
        modifier(ChartModifier(selected: selectedDate))
    }

    func chartSelected_X_String(_ selectedString: Binding<String?>) -> some View {
        modifier(ChartModifier(selected: selectedString))
    }
}

fileprivate struct ChartModifier<ValueType: Plottable>: ViewModifier {
    @Binding var selected: ValueType?

    func body(content: Content) -> some View {
        content
            .chartOverlay { chartProxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    selected = chartProxy.value(atX: value.location.x, as: ValueType.self)
                                }
                                .onEnded { _ in
                                    selected = nil
                                }
                        )
                        .onTapGesture(coordinateSpace: .local) { location in
                            selected = chartProxy.value(atX: location.x, as: ValueType.self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                selected = nil
                            }
                        }
                }
            }
    }
}
