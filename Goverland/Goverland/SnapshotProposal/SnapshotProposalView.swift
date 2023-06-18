//
//  SnapshotProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let proposal: Proposal
    
    var body: some View {
        Spacer()
//        NavigationStack {
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 0) {
//                    NavigationLink(destination: DaoInfoScreenView(event: event)) {
//                        SnapshotProposalHeaderView()
//                            .padding(.vertical, 20)
//                            .foregroundColor(.primary)
//                    }
//                    SnapshotProposalCreatorIdentityView()
//                        .padding(.bottom, 15)
//                    SnapshotProposalStatusBarView()
//                        .padding(.bottom, 20)
//                    SnapshotProposalDescriptionView()
//                        .padding(.bottom, 35)
//                    HStack {
//                        Text("Off-Chain Vote")
//                            .font(.headlineSemibold)
//                            .foregroundColor(.textWhite)
//                        Spacer()
//                    }
//                    .padding(.bottom)
//                    SnapshotProposalVoteTabView()
//                        .padding(.bottom, 35)
//                    SnapshotProposalTimelineView()
//                        .padding(.bottom, 20)
//                }
//                .padding(.horizontal)
//                .navigationBarBackButtonHidden()
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            self.presentationMode.wrappedValue.dismiss()
//                        } label: {
//                            Image(systemName: "arrow.left")
//                                .foregroundColor(.textWhite)
//                        }
//                    }
//                    ToolbarItem(placement: .principal) {
//                        VStack {
//                            Text("GnosisDAO")
//                                .font(.title3Semibold)
//                        }
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            // follow action
//                        } label: {
//                            Image(systemName: "bell.fill")
//                                .foregroundColor(.textWhite40)
//                        }
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Menu {
//                            Button("Share", action: performShare)
//                            Button("to Snapshot", action: performOpenSnapshot)
//                        } label: {
//                            Image(systemName: "ellipsis")
//                                .foregroundColor(.gray)
//                                .fontWeight(.bold)
//                                .frame(width: 20, height: 20)
//                        }
//                    }
//                }
//                .background(Color.surface)
//                .toolbarBackground(Color.surfaceBright, for: .navigationBar)
//                .onAppear() { Tracker.track(.snapshotProposalView) }
//            }
//            .background(Color.surfaceBright)
//        }
    }
    
    private func performShare() {}
    private func performOpenSnapshot() {}
}

struct SnapshotProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalView(proposal: .aaveTest)
    }
}
