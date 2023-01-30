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
        VStack{
            Text("Select DAOs")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField(
                        "Search 6032 DAOs by name",
                        text: $searchedText
                    )
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("lightGrey"))
            ).padding(.horizontal, 20)
            
            ScrollView {
                
                Text("Get Updates in your feed for the DAOs you select.")
                    .padding()
                
                HStack {
                    Text("Featured DAOs")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("See all")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                .padding()
                
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<5) { i in
                            VStack {
                                Image(systemName: "face.dashed.fill")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.gray).opacity(0.6)
                                Text("Uniswap DAO")
                                    .fontWeight(.medium)
                                Button("Follow", action: followButtonTapped)
                                    .frame(width: 110, height: 35, alignment: .center)
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                    .background(.blue)
                                    .cornerRadius(2)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color("lightGrey"), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                HStack {
                    Text("Social")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("See all")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                .padding()
                
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<5) { i in
                            VStack {
                                Image(systemName: "face.dashed.fill")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.gray).opacity(0.6)
                                Text("Uniswap DAO")
                                    .fontWeight(.medium)
                                Button("Follow", action: followButtonTapped)
                                    .frame(width: 110, height: 35, alignment: .center)
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                    .background(.blue)
                                    .cornerRadius(2)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color("lightGrey"), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func followButtonTapped() {}
}


struct SearchBarViewModel {
    
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}
