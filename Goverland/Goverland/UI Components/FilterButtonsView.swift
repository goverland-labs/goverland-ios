//
//  FilterButtonsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//  Copyright © Goverland Inc. All rights reserved.
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
        VStack {
            HStack(spacing: 0) {
                ForEach(T.allValues) { filterOption in
                    Text(filterOption.localizedName)
                        .padding(.bottom, 8)
                        .background(RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(filterOption.id == filter.id ? Color.primaryDim : Color.clear)
                            .frame(height: 4)
                            .offset(y: 2)
                            .clipped()
                            .frame(height: 2)
                            .offset(y: 9)
                        )
                        .padding(.top)
                        .font(.footnoteSemibold)
                        .foregroundStyle(filterOption.id == filter.id ? Color.primaryDim : .textWhite60)
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
        .overlay(Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color.containerBright), alignment: .bottom)
    }
}
