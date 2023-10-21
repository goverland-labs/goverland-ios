//
//  DaoInfoOnboardingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-20.
//

import SwiftUI

struct DaoInfoOnboardingView: View {
    
    var body: some View {
        List(0..<5) { index in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .frame(maxWidth: .infinity)
                VStack {
                    HStack {
                        Circle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(width: 16, height: 16)
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                            .frame(width: 80, height: 16)
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        if index == 0 {
                            VStack(alignment: .leading) {
                                Text("Don't hurry up!")
                                    .font(.headlineSemibold)
                                    .foregroundColor(Color.textWhite)
                                Text("Please finish onboarding to get into the full functionality of the application!")
                                    .font(.footnoteRegular)
                                    .foregroundColor(Color.textWhite)
                            }
                        }
                        
                        Spacer()
                        
                        Circle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                            .frame(width: 46, height: 46)
                    }
                    
                    Spacer()
                }
                .frame(height: 110)
                .padding()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 12))
            .listRowBackground(Color.clear)
            .padding(.top, 10)
        }
        .scrollIndicators(.hidden)
        .edgesIgnoringSafeArea(.all)
        .listStyle(.plain)
        .mask(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom))
    
    }
}

#Preview {
    DaoInfoOnboardingView()
}
