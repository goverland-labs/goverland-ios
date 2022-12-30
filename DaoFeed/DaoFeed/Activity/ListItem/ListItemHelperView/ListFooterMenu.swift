//
//  ListFooterMenu.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListFooterMenu: View {
    var body: some View {
        
        Menu {
            
            Button("Share", action: performShare)
            Button("Cancel", action: performCancel)
            
        } label: {
            
            Image(systemName: "ellipsis")
                .foregroundColor(.black)
            .fontWeight(.bold)
            
        }
    }
    
    private func performShare() {
        
    }
    
    private func performCancel() {
        
    }
}

struct ListFooterMenu_Previews: PreviewProvider {
    static var previews: some View {
        ListFooterMenu()
    }
}
