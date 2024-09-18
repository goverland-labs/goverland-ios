//
//  ChartFilters.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 22.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

protocol FilteringOption: Identifiable, Equatable {
    static var allOptions: [Self] { get }
    var localizedName: String { get }
}

enum DatesFiltetingOption: Int, FilteringOption {
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

    var localizedName: String {
        switch self {
        case .all: return "all"
        case .oneYear: return "1y"
        case .sixMonths: return "6m"
        case .threeMonths: return "3m"
        case .oneMonth: return "1m"
        }
    }

    var queryParamName: String {
        switch self {
        case .all: return "all"
        case .oneYear: return "1y"
        case .sixMonths: return "6m"
        case .threeMonths: return "3m"
        case .oneMonth: return "1m"
        }
    }
}

enum BucketGroupsFilteringOption: Int, FilteringOption {
    case one = 1
    case five = 5
    case ten = 10

    var id: Int {
        self.rawValue
    }

    static var allOptions: [Self] {
        [.one, .five, .ten]
    }

    var localizedName: String {
        "\(rawValue)"
    }
}

enum DistributionFilteringOption: Int, FilteringOption {
    case squareRoot = 0
    case log

    var id: Int {
        self.rawValue
    }

    static var allOptions: [Self] {
        [.squareRoot, .log]
    }

    var localizedName: String {
        switch self {
        case .squareRoot:
            "√"
        case .log:
            "log"
        }
    }
}

struct ChartFilters<Option: FilteringOption>: View {
    @Binding var selectedOption: Option
    private let options: [Option]
    private let optionMinWidth: CGFloat
    private let componentMaxHeight: CGFloat
    @Namespace var namespace

    init(selectedOption: Binding<Option>,
         options: [Option] = Option.allOptions,
         optionMinWidth: CGFloat = 30,
         componentMaxHeight: CGFloat = 28)
    {
        _selectedOption = selectedOption
        self.options = options
        self.optionMinWidth = optionMinWidth
        self.componentMaxHeight = componentMaxHeight
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(options, id: \.id) { option in
                    ZStack {
                        if selectedOption == option {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.secondaryContainer)
                                .matchedGeometryEffect(id: "option-background", in: namespace)
                                .frame(minWidth: optionMinWidth)
                        }

                        Text(option.localizedName)
                            .frame(minWidth: optionMinWidth)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .font(.caption2Semibold)
                            .foregroundStyle(Color.onSecondaryContainer)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.secondaryContainer, lineWidth: 1)
                                    .frame(minWidth: optionMinWidth)
                            )
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5)) {
                            selectedOption = option
                        }
                    }
                }
            }
            .padding(.leading, 4)
        }
        .frame(height: componentMaxHeight)
    }
}

#Preview {
    ChartFilters(selectedOption: .constant(DatesFiltetingOption.all))
}
