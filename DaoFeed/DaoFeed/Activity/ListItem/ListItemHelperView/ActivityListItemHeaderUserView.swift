//
//  ActivityListItemHeaderUserView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-30.
//

import SwiftUI

struct ActivityListItemHeaderUserView: View {
    
    private let user = User(address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b", image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39", name: "")
    
    var body: some View {
        
        // this logic should be in ViewModel
        if user.endsName != ""  {
            Text(user.endsName)
                .fontWeight(.semibold)
                .lineLimit(1)
        } else {
            Text(user.address)
                .fontWeight(.semibold)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}

struct ListItemHeaderUserView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemHeaderUserView()
    }
}
