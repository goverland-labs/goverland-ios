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
    
    var onSelect: (T) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(T.allValues) { filterOption in
                Text(filterOption.localizedName)
                    .padding(.bottom, 7)
                    .overlay(BottomBorder()
                        .stroke(filterOption.id == filter.id ? Color.primaryDim : Color.clear,
                                lineWidth: 3))
                    .padding(.top)
                    .font(.footnoteSemibold)
                    .foregroundColor(filterOption.id == filter.id ? .primaryDim : .textWhite60)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5)) {
                            self.filter = filterOption
                        }
                        onSelect(filterOption)
                    }
                    .padding([.leading, .trailing], 12)
            }
            
            Spacer()
        }
    }
}
