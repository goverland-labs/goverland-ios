//
//  ActivityFilterMenu.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

struct ActivityFilterMenu: View {
    
    @Binding var index: Int
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                
                Button(action: {
                    self.index = 0
                    print("All button tapped")
                }) {
                    ActivityFilterMenuItem(menuItemName: "All")
                        .background(Capsule().fill(0 == index ? .black : .white))
                        .foregroundColor(0 == index ? .white : .black)
                }
                
                Button(action: {
                    self.index = 1
                    print("Discussion button tapped")
                }) {
                    ActivityFilterMenuItem(menuItemName:    "Discussion")
                        .background(Capsule().fill(1 == index ? .black : .white))
                        .foregroundColor(1 == index ? .white : .black)
                }
                
                Button(action: {
                    self.index = 2
                    print("Vote button tapped")
                }) {
                    
                    ActivityFilterMenuItem(menuItemName: "Vote")
                        .background(Capsule().fill(2 == index ? .black : .white))
                        .foregroundColor(2 == index ? .white : .black)
                }
            }
        }
        .padding(.leading, 15)
        .padding(.top, 30)
        .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
    }
       
}

struct ActivityFilterMenuItem: View {
    
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
        ActivityFilterMenu(index: .constant(0))
    }
}
