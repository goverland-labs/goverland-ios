//
//  SnapshotProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposalView: View {
    let proposal: Proposal

    @State private var showDaoInfoView = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    SnapshotProposalHeaderView(title: proposal.title)
                        .gesture(TapGesture().onEnded { _ in
                            self.showDaoInfoView = true
                        })

                    SnapshotProposalCreatorIdentityView()
                        .padding(.bottom, 15)

                    SnapshotProposalStatusBarView()
                        .padding(.bottom, 20)

                    SnapshotProposalDescriptionView()
                        .padding(.bottom, 35)

                    HStack {
                        Text("Off-Chain Vote")
                            .font(.headlineSemibold)
                            .foregroundColor(.textWhite)
                        Spacer()
                    }
                    .padding(.bottom)

                    SnapshotProposalVoteTabView()
                        .padding(.bottom, 35)

                    SnapshotProposalTimelineView()
                        .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(proposal.dao.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // follow action
                        } label: {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.textWhite40)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Share", action: performShare)
                            Button("Open on Snapshot", action: performOpenSnapshot)
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .background(Color.surface)
                .onAppear() { Tracker.track(.snapshotProposalView) }
                .popover(isPresented: $showDaoInfoView) {
                    DaoInfoView()
                }
            }
            .background(Color.surfaceBright)
        }
    }
    
    private func performShare() {}
    private func performOpenSnapshot() {}
}

fileprivate struct SnapshotProposalHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .font(.title3Semibold)
            .foregroundColor(.textWhite)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.7)
    }
}


struct SnapshotProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalView(proposal: .aaveTest)
    }
}
