//
//  SearchView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var data = DaoDataService.data
    @State private var searchText = ""
    private let controls: [SearchViewControls] = [.DAOs, .Discussions, .Votes]
    @State private var currentControl: SearchViewControls = .DAOs
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ForEach(controls, id: \.self) { control in
                        VStack(spacing: 12) {
                            Text(control.rawValue)
                                .fontWeight(.semibold)
                                .foregroundColor(currentControl == control ? .primary : .gray)
                            ZStack {
                                if currentControl == control {
                                    Capsule(style: .continuous)
                                        .foregroundColor(.blue)
                                } else {
                                    Capsule(style: .continuous)
                                        .foregroundColor(.clear)
                                }
                            }.frame(width: 80, height: 2)
                        }
                        .onTapGesture {
                            withAnimation {
                                self.currentControl = control
                            }
                        }
                    }
                }
                .fontWeight(.semibold)
                .padding(.top)
                
                Capsule(style: .continuous)
                    .fill(.gray)
                    .frame(height: 1)
                
                if searchText != "" {
                    ScrollView(showsIndicators: false) {
                        ForEach(filterDaoList(searchText: searchText)) { dao in
                            HStack {
                                DaoImageInSearchView(imageURL: dao.image)
                                Text(dao.name)
                                Spacer()
                                FollowButtonView()
                            }
                            .padding(5)
                            .listRowSeparator(.hidden)
                        }
                        .padding()
                    }
                } else {
                    switch currentControl {
                    case .Discussions:
                        SearchDiscussionBodyView()
                    case .Votes:
                        SearchVoteBodyView()
                    default:
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(data.keys, id: \.self) { key in
                                    VStack {
                                        HStack {
                                            Text(key.name)
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("See all")
                                                .fontWeight(.medium)
                                                .foregroundColor(.blue)
                                        }
                                        .padding()
                                        
                                        DaoGroupThreadView(daoGroups: $data.daoGroups, daoGroupType: key, data: data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Look for DAO")
        }
    }
    
    
    private func getAllCashedDaos() -> [Dao] {
        var listDaos: [Dao] = []
        let data = DaoDataService.data
        for (_, daos) in data.daoGroups {
            listDaos.insert(contentsOf: daos, at: listDaos.count)
        }
        return listDaos
    }
    
    private func filterDaoList(searchText: String) -> [Dao] {
        return searchText == "" ? getAllCashedDaos() : getAllCashedDaos().filter { $0.name.contains(searchText) }
    }
}

fileprivate struct SearchDiscussionBodyView: View {
    @StateObject private var data = ActivityDataService.data
    
    var body: some View {
        List(0..<data.events.count, id: \.self) { index in
            ActivityListItemView(event: data.events[index])
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                .listRowBackground(Color.clear)
        }
        
        .onAppear() {
            ActivityDataService.data.getEvents(withFilter: .discussion, fromStart: true)
        }
    }
}

fileprivate struct SearchVoteBodyView: View {
    @StateObject private var data = ActivityDataService.data
    
    var body: some View {
        List(0..<data.events.count, id: \.self) { index in
            ActivityListItemView(event: data.events[index])
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                .listRowBackground(Color.clear)
        }
        .onAppear() {
            ActivityDataService.data.getEvents(withFilter: .vote, fromStart: true)
        }
    }
}

fileprivate enum SearchViewControls: String {
    case DAOs, Discussions, Votes
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
