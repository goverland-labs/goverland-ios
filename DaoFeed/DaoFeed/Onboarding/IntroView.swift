//
//  IntroView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct IntroView: View {
    
    @State var termsViewIsPresented = false
    @State var intros = IntroViewModel.data.intros
    @State var currentIndex: Int = 0

    var body: some View {
        VStack {
            ScrollView(.init(), showsIndicators: false) {
                CarouselView(intros: $intros, currentInde: $currentIndex)
            }
            .frame(height: 450)
            .padding(.top, 100)
            
            Spacer()
            Button("Get Started") {
                termsViewIsPresented = true
            }
            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
            .background(Color.blue)
            .clipShape(Capsule())
            .tint(.white)
            .fontWeight(.semibold)
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .sheet(isPresented: $termsViewIsPresented) {
            TermsView(termsViewIsPresented: $termsViewIsPresented)
                .presentationDetents([.medium, .large])
        }
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct CarouselView: View {
    
    @Binding var intros: [IntroModel]
    @Binding var currentInde: Int
    @State var index: Int = 0
    @State var offSet: CGFloat = 0
    
    var body: some View {
        TabView(selection: $index) {
            ForEach(intros.indices, id: \.self) { i in
                VStack {
                    // magic to switch carousel dots
                    // watching offset and calculate the index
                    // to switch dots color accordingly
                    if i == 0 {
                        Color.clear.overlay(
                            GeometryReader { proxy -> Color in
                                let minX = proxy.frame(in: .global).minX
                                DispatchQueue.main.async {
                                    withAnimation(.default) {
                                        self.offSet = -minX
                                    }
                                }
                                return Color.clear
                            }
                        ).frame(width: 0, height: 0)
                    }
                    
                    Image(systemName: intros[i].image)
                        .resizable()
                        .frame(width: 120, height: 180, alignment: .center)
                        .foregroundColor(.gray.opacity(0.6))
                    Text(intros[i].title)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                    Text(intros[i].description)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .padding(.horizontal, 40)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            HStack(spacing: 15) {
                ForEach(intros.indices, id: \.self) { index in
                    Capsule()
                        .fill(getIndex() == index ? .black : .gray)
                        .frame(width: 9, height: 9)
                }
            }
            .alignmentGuide(.bottom) {$0[.bottom]}
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func getIndex() -> Int {
        return Int(round(Double(offSet / UIScreen.main.bounds.width)))
    }
}

struct IntroModel: Identifiable {
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

class IntroViewModel: ObservableObject {
    
    @Published var intros: [IntroModel] = []
    static let data = IntroViewModel()
    
    private init() {
        getIntros()
    }
    
    func getIntros() {
        let intro1 = IntroModel.init(id: UUID(),
                                     title: "Follow important updates from your vorite DAOs",
                                     description: "Receive push notifications",
                                     image: "apps.iphone")
        let intro2 = IntroModel.init(id: UUID(),
                                     title: "Follow important updates from your vorite DAOs",
                                     description: "Receive push notifications",
                                     image: "building.columns")
        let intro3 = IntroModel.init(id: UUID(),
                                     title: "Follow important updates from your vorite DAOs",
                                     description: "Receive push notifications",
                                     image: "iphone.gen1")
        intros.append(contentsOf: [intro1, intro2, intro3])
    }
    
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
