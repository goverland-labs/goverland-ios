//
//  DaoDetailView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-16.
//

import SwiftUI

struct DaoDetailView: View {
    
    var dao: Dao
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DaoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DaoDetailView(dao: Dao.init(id: UUID(), name: "", image: nil))
    }
}
