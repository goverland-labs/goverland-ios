//
//  EcosystemChartsFullView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-28.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

enum EcosystemFilter: Int, FilterOptions {
    case daos = 0
    case voters
    case proposals

    var localizedName: String {
        switch self {
        case .daos:
            return "DAOs"
        case .voters:
            return "Voters"
        case .proposals:
            return "Proposals"
        }
    }
}

struct EcosystemChartsFullView: View {
    @State private var filter: EcosystemFilter = .daos
    var body: some View {
        VStack {
            VStack {
                FilterButtonsView<EcosystemFilter>(filter: $filter) { _ in }
                
                switch filter {
                case .daos: MonthlyTotalDaosView()
                case .voters: MonthlyTotalVotersView()
                case .proposals: MonthlyTotalNewProposalsView()
                }
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Ecosystem")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                }
            }
        }
    }
}
