//
//  ChartSelectedDateExtension.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.11.23.
//

import SwiftUI

extension View {
    func chartSelectedDate(_ selectedDate: Binding<Date?>) -> some View {
        modifier(ChartModifier(selectedDate: selectedDate))
    }
}

fileprivate struct ChartModifier: ViewModifier {
    @Binding var selectedDate: Date?

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
                                    selectedDate = chartProxy.value(atX: value.location.x, as: Date.self)
                                }
                                .onEnded { _ in
                                    selectedDate = nil
                                }
                        )
                        .onTapGesture(coordinateSpace: .local) { location in
                            selectedDate = chartProxy.value(atX: location.x, as: Date.self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                selectedDate = nil
                            }
                        }
                }
            }
    }
}
