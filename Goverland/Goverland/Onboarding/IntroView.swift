//
//  IntroView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct IntroView: View {
    @State var termsViewIsPresented = false

    var body: some View {
        VStack {
            CarouselView()
                .frame(height: UIScreen.screenHeight * 2 / 3)
                .padding(.top, UIScreen.screenHeight / 8)
            
            Spacer()

            // TODO: move to UI component
            Button("Get Started") {
                termsViewIsPresented = true
            }
            .ghostActionButtonStyle()
            .padding(.bottom, 50)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .sheet(isPresented: $termsViewIsPresented) {
            TermsView(termsViewIsPresented: $termsViewIsPresented)
                .presentationDetents([.medium, .large])
        }
        .onAppear() { Tracker.track(.introView) }
    }
}

fileprivate struct CarouselView: View {
    @State private var index: Int = 0

    let intros: [IntroModel] = [
        IntroModel(id: UUID(),
                   title: "Follow important updates from your vorite DAOs",
                   description: "Receive push notifications",
                   image: "apps.iphone"),
        IntroModel(id: UUID(),
                   title: "Follow important updates from your vorite DAOs",
                   description: "Receive push notifications",
                   image: "building.columns"),
        IntroModel(id: UUID(),
                   title: "Follow important updates from your vorite DAOs",
                   description: "Receive push notifications",
                   image: "iphone.gen1")
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabView(selection: $index) {
                    ForEach(0..<intros.count, id: \.self) { index in
                        VStack {
                            Image(systemName: intros[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / 2,
                                       height: geometry.size.height / 2,
                                       alignment: .center)
                                .foregroundColor(.gray.opacity(0.6))
                            Text(intros[index].title)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.top, 50)
                            Text(intros[index].description)
                                .padding(.top, 5)
                        }
                        .padding(.horizontal, 40)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 20) {
                    ForEach(0..<intros.count, id: \.self) { index in
                        Circle()
                            .fill(index == self.index ? Color.black : Color.black.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
    }
}

fileprivate struct IntroModel: Identifiable, Hashable{
    let id: UUID
    let title: String
    let description: String
    let image: String
    
    init(id: UUID, title: String, description: String, image: String) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
