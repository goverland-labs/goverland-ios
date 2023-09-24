//
//  ProfileSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    private let user = User.aaveChan
    private let devices = [["IPhone 14 Pro", "Sandefjord, Norway", "online"],
                           ["IPhone 13", "Tbilisi, Georgia", "Apr 10"]]
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 70, height: 70)
            Text((user.resolvedName != nil) ? user.resolvedName! : "Unnamed")
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
        }
        List {
            Section() {
                NavigationLink("", destination: EmptyView())
                    .background(
                        HStack {
                            Text("Accounts")
                            Spacer()
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17)
                                .foregroundColor(Color.onPrimary)
                        }
                            .foregroundColor(Color.onPrimary)
                    )
                    .listRowBackground(Color.primaryDim)
                
                if user.resolvedName != nil {
                    NavigationLink("", destination: EmptyView())
                        .frame(height: 40)
                        .background(
                            HStack {
                                Image(systemName: "circle")
                                    .frame(width:20, height: 20)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(user.resolvedName!)
                                        .font(.bodyRegular)
                                        .foregroundColor(.textWhite)
                                    Text(user.address.short)
                                        .font(.сaptionRegular)
                                        .foregroundColor(.textWhite60)
                                }
                                Spacer()
                            })
                }
                
                NavigationLink("", destination: EmptyView())
                    .background(
                        HStack {
                            HStack {
                                Image(systemName: "circle")
                                    .frame(width:20, height: 20)
                                Text(user.address.short)
                                    .font(.bodyRegular)
                                    .foregroundColor(.textWhite)
                            }
                            Spacer()
                        })
            }
            
            Section(header: Text("Devices")) {
                ForEach(devices.indices) { i in
                    NavigationLink("", destination: EmptyView())
                        .frame(height: 40)
                        .background(
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(devices[i][0])
                                        .font(.bodyRegular)
                                        .foregroundColor(.textWhite)
                                    Text("\(devices[i][1]) - \(devices[i][2])")
                                        .font(.footnoteRegular)
                                        .foregroundColor(.textWhite60)
                                }
                                Spacer()
                            }
                        )}
            }
            
            Section() {
                NavigationLink("Sign out", destination: EmptyView())
            }
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
