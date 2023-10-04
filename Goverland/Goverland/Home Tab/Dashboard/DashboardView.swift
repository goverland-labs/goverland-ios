//
//  DashboardView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import SwiftUI

fileprivate enum Path {
    case topProposals
}

struct DashboardView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                Text("Dashboard")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Dashboard")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "envelope")
                        .foregroundColor(.primary)
                        .onTapGesture {
                            ActiveHomeViewManager.shared.activeView = .inbox
                        }
                }
            }
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .topProposals: EmptyView()
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
