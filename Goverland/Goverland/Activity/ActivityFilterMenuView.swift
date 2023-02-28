//
//  ActivityFilterMenuView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

struct ActivityFilterMenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var filter: FilterType
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                
                Button(action: {
                    self.filter = .all
                    ActivityDataService.data.getEvents(withFilter: .all, fromStart: true)
                }) {
                    if colorScheme == .dark {
                        ActivityFilterMenuItem(menuItemName: "All")
                            .background(Capsule().fill(filter == .all ? .white : .darkGray))
                            .foregroundColor(filter == .all ? .black : .gray)
                    } else {
                        ActivityFilterMenuItem(menuItemName: "All")
                            .background(Capsule().fill(filter == .all ? .black : .white))
                            .foregroundColor(filter == .all ? .white : .black)
                    }
                }
                
                Button(action: {
                    self.filter = .discussion
                    ActivityDataService.data.getEvents(withFilter: .discussion, fromStart: true)
                }) {
                    if colorScheme == .dark {
                        ActivityFilterMenuItem(menuItemName: "Discussion")
                            .background(Capsule().fill(filter == .discussion ? .white : .darkGray))
                            .foregroundColor(filter == .discussion ? .black : .gray)
                    } else {
                        ActivityFilterMenuItem(menuItemName: "Discussion")
                            .background(Capsule().fill(filter == .discussion ? .black : .white))
                            .foregroundColor(filter == .discussion ? .white : .black)
                    }
                }
                
                Button(action: {
                    self.filter = .vote
                    ActivityDataService.data.getEvents(withFilter: .vote, fromStart: true)
                }) {
                    if colorScheme == .dark {
                        ActivityFilterMenuItem(menuItemName: "Vote")
                            .background(Capsule().fill(filter == .vote ? .white : .darkGray))
                            .foregroundColor(filter == .vote ? .black : .gray)
                    } else {
                        ActivityFilterMenuItem(menuItemName: "Vote")
                            .background(Capsule().fill(filter == .vote ? .black : .white))
                            .foregroundColor(filter == .vote ? .white : .black)
                    }
                }
            }
        }
        .padding(.leading, 15)
        .padding(.top, 30)
        .background(Color("lightGrey"))
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
        ActivityFilterMenuView(filter: .constant(.vote))
    }
}
