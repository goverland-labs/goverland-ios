//
//  BottomRightEllipsisView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct BottomRightEllipsisView<Content: View>: View {
    @Binding var isMenuOpened: Bool
    let menuContent: Content

    init(isMenuOpened: Binding<Bool>,
        @ViewBuilder menuContent: () -> Content)
    {
        self._isMenuOpened = isMenuOpened
        self.menuContent = menuContent()
    }

    var body: some View {
        // Place into botter right corner
        VStack {
            Spacer()
            HStack {
                Spacer()
                // TODO: Magic. Using HStack here crashes the app. With LazyVStack app doesn't crash,
                // but it still glitches a bit and there are errors in the console:
                // List failed to visit cell content, returning an empty cell.
                LazyVStack(alignment: .trailing) {
                    Menu {
                        menuContent
                            .onAppear {
                                isMenuOpened = true
                            }
                            .onDisappear {
                                isMenuOpened = false
                            }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.textWhite40)
                            .fontWeight(.heavy)
                            .frame(width: 56, height: 40)
                    }
                }
            }
        }
    }
}
