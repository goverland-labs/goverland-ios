//
//  ActivityListItemBodyView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ActivityListItemBodyView: View {
    
    var event: Event
    var isWarningSubtitle: Bool = true
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                
                Text("UIP23 - DAO Operations Budget")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .lineLimit(2)
                
                Text("2 days left to vote vs snapshot")
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if isWarningSubtitle {
                    Text("Waiting for execution")
                        .foregroundColor(.yellow)
                }
                
            }
            
            Spacer()
            
            Image(systemName: "face.smiling")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.pink)
        }
    }
}

struct ListItemBody_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemBodyView(event: Event(type: .discussion, meta: []))
    }
}
