//
//  ActivityFilterMenuView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

struct ActivityFilterMenuView: View {
    @Binding var filter: FilterType
    var data: ActivityDataService
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                
                Button(action: {
                    self.filter = .all
                    data.getEvents(withFilter: .all, fromStart: true)
                }) {
                    ActivityFilterMenuItem(menuItemName: "All")
                        .background(Capsule().fill(filter == .all ? .primary : Color("white-darkGray")))
                        .foregroundColor(filter == .all ? Color("white-black") : Color("black-gray"))
                    
                }
                
                Button(action: {
                    self.filter = .discussion
                    data.getEvents(withFilter: .discussion, fromStart: true)
                }) {
                    ActivityFilterMenuItem(menuItemName: "Discussion")
                        .background(Capsule().fill(filter == .discussion ? .primary : Color("white-darkGray")))
                        .foregroundColor(filter == .discussion ? Color("white-black") : Color("black-gray"))
                    
                }
                
                Button(action: {
                    self.filter = .vote
                    data.getEvents(withFilter: .vote, fromStart: true)
                }) {
                    ActivityFilterMenuItem(menuItemName: "Vote")
                        .background(Capsule().fill(filter == .vote ? .primary : Color("white-darkGray")))
                        .foregroundColor(filter == .vote ? Color("white-black") : Color("black-gray"))
                }
            }
        }
        .padding(.leading, 15)
        .padding(.top, 30)
        .background(Color("lightGray-black"))
    }
       
}

fileprivate struct ActivityFilterMenuItem: View {
    
    var menuItemName: String
    
    var body: some View {
        
        Text(menuItemName)
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 10)
            .fontWeight(.bold)
            .cornerRadius(5)
    }
}

struct ActivityFilterMenu_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFilterMenuView(filter: .constant(.vote), data: ActivityDataService())
    }
}
