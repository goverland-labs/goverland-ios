//
//  ActivityView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct ActivityView: View {
    
    @State private var filter: FilterType = .all
    @StateObject private var data = ActivityDataService.data

    var body: some View {        
        
        VStack(spacing: 10) {
            
            ActivityFilterMenuView(filter: $filter)
            
            List(0..<data.events.count, id: \.self) { index in
                
                ActivityViewListView(index: index)
                
            }
            .listStyle(.plain)
            .padding(.horizontal, 10)
            .scrollIndicators(.hidden)
            .refreshable {
                do {
                    // api will be called here
                    // 3 sec delay for now to imitate
                    try await Task.sleep(for: Duration.seconds(3))
                        data.getEvents(withFilter: filter)
                } catch {
                    // will handle api errors here
                    
                }
            }
        }
        .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
    }
}

fileprivate struct ActivityViewListView: View {
    
    @StateObject private var data = ActivityDataService.data
    @State private var filter: FilterType = .all
    var index: Int
    
    var body: some View {
        
        if index == data.events.count - 1 {
            ActivityListItemView(event: data.events[index])
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
                    .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                    .padding(.top, 10)
                    .onAppear {
                        data.getEvents(withFilter: filter)
                    }
        } else {
            ActivityListItemView(event: data.events[index])
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
                    .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                    .padding(.top, 10)
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
