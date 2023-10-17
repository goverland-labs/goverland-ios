//
//  DashboardView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import SwiftUI

fileprivate enum Path {
    case hotProposals
}

struct DashboardView: View {
    @State private var path = NavigationPath()
    @StateObject private var dataSource = DashboardViewDataSource.shared
    @Setting(\.unreadEvents) var unreadEvents
    @State private var animate = false

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                SectionHeader(header: "Hot Proposals") {
                    path.append(Path.hotProposals)
                }
                DashboardHotProposalsView(path: $path)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Goverland")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if #available(iOS 17, *) {
                        Image(systemName: "envelope.badge.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(unreadEvents > 0 ? Color.primary : Color.textWhite, Color.textWhite)
                            .symbolEffect(.bounce.up.byLayer, options: .speed(0.3), value: animate)
                            .onTapGesture {
                                ActiveHomeViewManager.shared.activeView = .inbox
                            }
                    } else {
                        Image(systemName: "envelope.badge.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(unreadEvents > 0 ? Color.primary : Color.textWhite, Color.textWhite)
                            .onTapGesture {
                                ActiveHomeViewManager.shared.activeView = .inbox
                            }
                    }
                }
            }
//            .refreshable {
//                TopProposalsDataSource.dashboard.refresh()
//            }
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .hotProposals: EmptyView()
                }
            }
            .onAppear {
                animate.toggle()
                // TODO: track
            }
        }
    }
}

fileprivate struct SectionHeader: View {
    let header: String
    let onTap: (() -> Void)?

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 32)

            HStack {
                Text(header)
                    .font(.title2Semibold)
                Spacer()
                if onTap != nil {
                    Image(systemName: "arrow.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            .foregroundStyle(Color.textWhite)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap?()
            }
        }
    }
}
