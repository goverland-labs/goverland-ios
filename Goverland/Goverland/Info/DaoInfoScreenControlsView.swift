//
//  DaoInfoScreenControlsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-08.
//

import SwiftUI

struct DaoInfoScreenControlsView: View {
    
    @State private var currentControl: DaoInfoScreenControls = .activity
    private let controls: [DaoInfoScreenControls] = [.activity, .about]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                HStack(spacing: 20) {
                    ForEach(controls, id: \.self) { control in
                        VStack(spacing: 12) {
                            Text(control.rawValue.capitalized)
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
                    FollowButtonView(buttonWidth: 120, buttonHeight: 35)
                    Spacer()
                }
                .frame(height: 50)
            }.padding(.horizontal)
            
            Capsule(style: .continuous)
                .fill(.gray)
                .frame(height: 1)
            
            ZStack {
                if currentControl == .activity {
                    ActivityView()
                }
            }
        }
    }
}

fileprivate enum DaoInfoScreenControls: String {
    case activity, about
}

struct DaoInfoScreenControlsView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoScreenControlsView()
    }
}
