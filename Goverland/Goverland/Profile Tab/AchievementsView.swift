//
//  AchievementsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-05.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct Picture: Identifiable, Hashable {
    var id = UUID()
    var imageName: String
    var isVisible: Bool
}

struct AchievementsView: View {
    let pictures = [
            Picture(imageName: "first-tester", isVisible: true),
            Picture(imageName: "first-tester 1", isVisible: false),
            Picture(imageName: "first-tester 2", isVisible: false),
            Picture(imageName: "first-tester 3", isVisible: false),
            Picture(imageName: "first-tester 4", isVisible: false),
            Picture(imageName: "first-tester 5", isVisible: false)
        ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 100, maximum: 200), spacing: 15),
                GridItem(.flexible(minimum: 100, maximum: 200))
            ], spacing: 15, content: {
                ForEach(pictures) { picture in
                    ZStack {
                        Image(picture.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .background(Color.container)
                            .cornerRadius(20)
                        
                        if !picture.isVisible {
                            VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .cornerRadius(20)
                                .opacity(0.9)
                            
                            
                            HStack {
                                Spacer()
                                Text("COMMING SOON")
                                Spacer()
                            }
                            .font(.headlineSemibold)
                            .foregroundColor(.textWhite60)
                        }
                    }
                }
            })
            .padding()
        }
    }
}

private struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
