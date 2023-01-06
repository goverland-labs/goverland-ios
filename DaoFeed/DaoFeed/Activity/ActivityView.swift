//
//  ActivityView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct ActivityView: View {
    
    @State private var index: Int = 0
    @StateObject private var data = ActivityDataService.data
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            ActivityFilterMenu(index: self.$index)
            
            List {
                ForEach(data.events) { event in
                    
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
            .refreshable {
                print("refreshed")
                do {
                    // api will be called here
                    // 5 sec delay for now to emetate
                    try? await Task.sleep(for: Duration.seconds(5))
                    ActivityDataService.data.refreshedEvents()
                } catch {
                    // will handle api errors here
                    
                }
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
