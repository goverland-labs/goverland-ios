//
//  FilterButtonsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

protocol FilterOptions: CaseIterable & Identifiable & RawRepresentable where Self.RawValue == Int {
    var localizedName: String { get }
}

extension FilterOptions {
    var id: Int { self.rawValue }

    static var allValues: [Self] {
        return Array(Self.allCases.sorted { $0.rawValue < $1.rawValue })
    }
}

struct FilterButtonsView<T: FilterOptions>: View {
    @Binding var filter: T
    @Namespace var namespace

    var onSelect: (T) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(T.allValues) { filterOption in
                    ZStack {
                        if filter.id == filterOption.id {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.primary)
                                .frame(height: 36)
                                .matchedGeometryEffect(id: "filter-background", in: namespace)
                        }
                        Text(filterOption.localizedName)
                            .padding(16)
                            .font(.footnoteSemibold)
                            .foregroundColor(filterOption.id == filter.id ? .surfaceBright : .textWhite)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5)) {
                            self.filter = filterOption
                        }
                        onSelect(filterOption)
                    }
                    .padding([.leading, .trailing], 12)
                }
            }
        }
    }
}
