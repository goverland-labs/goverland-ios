//
//  SearchView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var data = CategoryDaosDataSource(category: .social)
    @State private var searchText = ""
    private let controls: [SearchViewControls] = SearchViewControls.all
    @State private var currentControl: SearchViewControls = .daos
    
    var body: some View {
        Text("TODO")
//        NavigationStack {
//            VStack(alignment: .leading, spacing: 0) {
//                HStack {
//                    ForEach(controls, id: \.self) { control in
//                        VStack(spacing: 12) {
//                            Text(control.localizedString)
//                                .fontWeight(.semibold)
//                                .foregroundColor(currentControl == control ? .primary : .gray)
//                            Capsule(style: .continuous)
//                                .foregroundColor(currentControl == control ? .primaryDim : .clear)
//                                .frame(width: 80, height: 2)
//                        }
//                        .onTapGesture {
//                            withAnimation {
//                                self.currentControl = control
//                            }
//                        }
//                    }
//                }
//                .fontWeight(.semibold)
//                .padding(.top)
//
//                Capsule(style: .continuous)
//                    .fill(.gray)
//                    .frame(height: 1)
//
//                if searchText != "" {
//                    ScrollView(showsIndicators: false) {
//                        ForEach(data.daos) { dao in
//                            HStack {
//                                RoundPictureView(image: dao.image, imageSize: 50)
//                                Text(dao.name)
//                                Spacer()
//                                FollowButtonView(buttonWidth: 110, buttonHeight: 35)
//                            }
//                            .padding(5)
//                            .listRowSeparator(.hidden)
//                        }
//                        .padding()
//                    }
//                } else {
//                    switch currentControl {
//                    case .daos:
//                        ScrollView(showsIndicators: false) {
//                            VStack {
//                                ForEach(data.caregories) { key in
//                                    VStack {
//                                        HStack {
//                                            Text(key.name)
//                                                .fontWeight(.semibold)
//                                            Spacer()
//                                            Text("See all")
//                                                .fontWeight(.medium)
//                                                .foregroundColor(.blue)
//                                        }
//                                        .padding()
//                                        DaoGroupThreadView(category: key)
//                                    }
//                                }
//                            }
//                        }
//                        .onAppear {
//                            Tracker.track(.searchDaoView)
//                            data.loadCategories()
//                        }
//                    case .discussions:
//                        SearchDiscussionBodyView()
//                            .onAppear { Tracker.track(.searchDiscussionView) }
//                    case .votes:
//                        SearchVoteBodyView()
//                            .onAppear { Tracker.track(.searchVoteView) }
//                    }
//                }
//            }
//            .searchable(text: $searchText, prompt: "Look for DAO")
//        }
    }
}

fileprivate struct SearchDiscussionBodyView: View {
    @StateObject private var data = InboxDataService(filter: .vote)
    
    var body: some View {
        List(0..<data.events.count, id: \.self) { index in
            ProposalListItemView(event: data.events[index])
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                .listRowBackground(Color.clear)
        }
    }
}

fileprivate struct SearchVoteBodyView: View {
    @StateObject private var data = InboxDataService(filter: .vote)
    
    var body: some View {
        List(0..<data.events.count, id: \.self) { index in
            ProposalListItemView(event: data.events[index])
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                .listRowBackground(Color.clear)
        }
    }
}

fileprivate enum SearchViewControls {
    case daos, discussions, votes

    static var all: [Self] { return [.daos, .discussions, .votes] }

    var localizedString: String {
        switch self {
        case .daos: return "DAOs"
        case .discussions: return "Discussions"
        case .votes: return "Votes"
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
