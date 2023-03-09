//
//  DaoInfoScreenControlsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-08.
//

import SwiftUI

struct DaoInfoScreenControlsView: View {
    
    
    @State private var currentControl = "Activity"
    private let controls = ["Activity", "About"]
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                ForEach(controls, id: \.self) { control in
                    VStack(spacing: 12) {
                        Text(control)
                            .fontWeight(.semibold)
                            .foregroundColor(currentControl == control ? .primary : .gray)
                        ZStack {
                            if currentControl == control {
                                Capsule(style: .continuous)
                                    .foregroundColor(.blue)
                            } else {
                                Capsule(style: .continuous)
                                    .foregroundColor(.clear)
                            }
                        }.frame(width: 60, height: 2)
                    }
                    .onTapGesture {
                        withAnimation {
                            self.currentControl = control
                        }
                    }
                }
            }
            .foregroundColor(.primary)
            .fontWeight(.semibold)
            
            Spacer()
            
            VStack {
                FollowingButtonView()
                Spacer()
            }
            .frame(height: 60)
        }
    }
}

fileprivate struct FollowingButtonView: View {
    
    @State private var didTap: Bool = true
    
    var body: some View {
        Button(action: { didTap.toggle() }) {
            Text(didTap ? "Following" : "Follow")
        }
        .frame(width: 120, height: 35, alignment: .center)
        .foregroundColor(didTap ? .blue : .white)
        .fontWeight(.medium)
        .background(didTap ? Color("followButtonColorActive") : Color.blue)
        .cornerRadius(3)
    }
}

struct DaoInfoScreenControlsView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoScreenControlsView()
    }
}
