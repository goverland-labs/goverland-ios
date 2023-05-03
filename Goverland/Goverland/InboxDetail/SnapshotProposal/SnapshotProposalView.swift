//
//  SnapshotProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var event: InboxEvent
    
    var data: VoteEventData {
        event.data as! VoteEventData
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    NavigationLink(destination: DaoInfoScreenView(event: event)) {
                        SnapshotProposaHeaderView()
                            .padding(.vertical, 20)
                            .foregroundColor(.primary)
                    }
                    SnapshotProposalCreatorIdentityView()
                        .padding(.bottom, 15)
                    SnapshotProposaStatusBarView()
                        .padding(.bottom, 20)
                    SnapshotProposaDescriptionView()
                        .padding(.bottom, 25)
                    HStack {
                        Text("Off-Chain Мote")
                            .font(.headlineSemibold)
                            .foregroundColor(.textWhite)
                        Spacer()
                    }
                    SnapshotProposaVoteTabView()
                        .padding(.bottom, 30)
                    SnapshotProposaTimelineView()
                        .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .navigationBarBackButtonHidden()
                .scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.textWhite)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("GnosisDAO")
                                .font(.title3Semibold)
                        }
                    }
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
                            Button("to Snapshot", action: performOpenSnapshot)
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .background(Color.surface)
                .toolbarBackground(Color.surfaceBright, for: .navigationBar)
                .onAppear() { Tracker.track(.stapshotProposalView) }
            }
            .background(Color.surfaceBright)
        }
    }
    
    private func performShare() {}
    private func performOpenSnapshot() {}

}

struct SnapshotProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalView(event: .vote1)
    }
}
