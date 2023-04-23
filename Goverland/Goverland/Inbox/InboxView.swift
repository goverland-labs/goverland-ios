//
//  InboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct InboxView: View {
    @State private var filter: FilterType = .all

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                InboxFilterMenuView(filter: $filter)
                    .padding(10)
                    .background(Color.surfaceBright)
                switch filter {
                case .all:
                    ProposalListItemView()
                case .vote:
                    ProposalListItemView()
                case .treasury:
                    TreasuryListItmeView()
                }
            }
            .background(Color.surface)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Inbox")
                            .font(.title3Semibold)
                    }
                }
            }
            .toolbarBackground(Color.surfaceBright, for: .navigationBar)
            
        }
        .onAppear() { Tracker.track(.inboxView) }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
