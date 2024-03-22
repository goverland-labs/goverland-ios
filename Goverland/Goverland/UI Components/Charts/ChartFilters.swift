//
//  ChartFilters.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 22.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

enum ChartFiltetingOption: Int, Identifiable {
    case all = 0
    case oneYear
    case sixMonths
    case threeMonths
    case oneMonth

    var id: Int {
        self.rawValue
    }

    static var allOptions: [Self] {
        [.all, .oneYear, .sixMonths, .threeMonths, .oneMonth]
    }

    func localizedName() -> String {
        switch self {
        case .all: return "all"
        case .oneYear: return "1y"
        case .sixMonths: return "6m"
        case .threeMonths: return "3m"
        case .oneMonth: return "1m"
        }
    }
}

struct ChartFilters: View {
    @State private var selectedOption: ChartFiltetingOption
    private let options: [ChartFiltetingOption]
    @Namespace var namespace

    init(selectedOption: ChartFiltetingOption = .oneYear,
         options: [ChartFiltetingOption] = ChartFiltetingOption.allOptions) {
        _selectedOption = State(wrappedValue: selectedOption)
        self.options = options
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(options) { option in
                    ZStack {
                        if selectedOption == option {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.secondaryContainer)
                                .matchedGeometryEffect(id: "option-background", in: namespace)
                        }

                        Text(option.localizedName())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .font(.caption2Semibold)
                            .foregroundStyle(Color.onSecondaryContainer)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.secondaryContainer, lineWidth: 1)
                            )
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5)) {
                            selectedOption = option
                        }
                    }
                }
            }
        }
        .frame(height: 26)
    }
}

#Preview {
    ChartFilters()
}
