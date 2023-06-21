//
//  SnapshotProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI
import SwiftDate


// TODO: add pull-to-refresh logic
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

                    SnapshotProposalCreatorView(dao: proposal.dao, creator: proposal.user)
                        .padding(.bottom, 15)

                    SnapshotProposalStatusBarView(state: proposal.state, votingEnd: proposal.votingEnd)
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
                    DaoInfoView(daoID: proposal.dao.id)
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

fileprivate struct SnapshotProposalCreatorView: View {
    let dao: Dao
    let creator: User

    var body: some View {
        HStack(spacing: 5) {
            // DAO identity view
            HStack(spacing: 6) {
                RoundPictureView(image: dao.image, imageSize: 16)
                Text(dao.name)
                    .font(.footnoteRegular)
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .foregroundColor(.textWhite)

            }
            Text("by")
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite60)
            IdentityView(user: creator)
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite)
            Spacer()
        }
    }
}

fileprivate struct SnapshotProposalStatusBarView: View {
    let state: Proposal.State
    let votingEnd: Date

    var body: some View {
        HStack {
            ProposalStatusView(state: state)
            Spacer()
            HStack(spacing: 0) {
                Text("Vote finishes ")
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite)
                DateView(date: votingEnd,
                         style: .numeric,
                         font: .footnoteRegular,
                         color: .textWhite)
            }
        }
        .padding(10)
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}

fileprivate struct SnapshotProposalDescriptionView: View {
    var body: some View {
        VStack {
            Text("GIP-77 proposed to both add improved delegation to the Gnosis DAO and to take measures to reduce spam in the GnosisDAO snapshot space. While implementation for the former is still underway, a recent update to Snapshot now allows spaces to define moderators who are able to hide spam proposals without having admin control over other sensitive settings in the Snapshot")
                .font(.bodyRegular)
                .foregroundColor(.textWhite)
                .overlay(ShadowOverlay(), alignment: .bottom)

            Button("Read more") {
                print("reading")
            }
            .ghostReadMoreButtonStyle()
        }
    }

    struct ShadowOverlay: View {
        var body: some View {
            Rectangle().fill(
                LinearGradient(colors: [.clear, .surface.opacity(0.8)],
                               startPoint: .top,
                               endPoint: .bottom))
            .frame(height: 50)
        }
    }
}

fileprivate struct SnapshotProposalTimelineView: View {
    private let testDates = [Date.now]
    private let testEvents = ["Snapshot vote created by ", "Discussion started by "]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Timeline")
                .font(.headlineSemibold)
                .foregroundColor(.textWhite)

            ForEach(0..<2) { i in
                HStack(spacing: 2) {
                    //DateView(date: Date("Nov 5, 2022") ?? Date.now)
                    Text("Nov 5, 2022 - ")
                    Text(testEvents[i])
                    IdentityView(user: .test)
                }
                .font(.footnoteRegular)
                .foregroundColor(.textWhite)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            }
        }
    }
}


struct SnapshotProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalView(proposal: .aaveTest)
    }
}