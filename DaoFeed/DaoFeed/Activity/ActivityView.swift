//
//  ActivityView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct ActivityView: View {
    
    @State private var index: Int = 0
    
    var events: [ActivityEvent] = ActivityDataService
        .data.getEvents()
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            ActivityFilterMenu(index: self.$index)
            
            List {
                ForEach(events) { event in
                    
                    ActivityListItemView(event: event)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
                        .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                        .padding(.top, 10)
                        
                }
            }
            .listStyle(.plain)
            .padding(.horizontal, 10)
            .scrollIndicators(.hidden)
        }
        .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
    }
}





struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
