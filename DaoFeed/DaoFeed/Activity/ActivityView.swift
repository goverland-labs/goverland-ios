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
                // need to add validation, that URL is valid (API valid and returning data)
                if index == data.events.count - 1 && data.hasNextPageURL() {
                    
                    ActivityListItemView(event: data.events[index])
                        .redacted(reason: .placeholder)
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
            .listStyle(.plain)
            .padding(.horizontal, 10)
            .scrollIndicators(.hidden)
            .refreshable {
                data.reset()
                data.getEvents(withFilter: filter)
            }
        }
        .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
