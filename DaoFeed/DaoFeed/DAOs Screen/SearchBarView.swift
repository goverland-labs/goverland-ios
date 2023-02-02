//
//  SearchBarView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct SearchBarView: View {
    
    @State var searchedText: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(
                "Search 6032 DAOs by name",
                text: $searchedText
            )
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("lightGrey"))
        ).padding(.horizontal, 20)
    }
}


struct SearchBarViewModel {
    
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}
