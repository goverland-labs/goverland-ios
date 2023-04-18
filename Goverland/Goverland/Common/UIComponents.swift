//
//  UIComponents.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-14.
//

import SwiftUI
import Kingfisher

struct DaoPictureView: View {
    let daoImage: URL?
    let imageSize: Int
    var body: some View {
        KFImage(daoImage)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: CGFloat(imageSize), height: CGFloat(imageSize)), mode: .aspectFill))
            .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
            .cornerRadius(CGFloat(imageSize / 2))
    }
}

struct UserPictureView: View {
    let userImage: URL?
    let imageSize: Int
    var body: some View {
        KFImage(userImage)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.purple)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: imageSize, height: imageSize), mode: .aspectFit))
            .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
    }
}

struct FollowButtonView: View {
    @State private var didTap: Bool = false
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    
    var body: some View {
        Button(action: { didTap.toggle() }) {
            Text(didTap ? "Following" : "Follow")
        }
        .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
        .foregroundColor(didTap ? .blue : .white)
        .fontWeight(.medium)
        .background(didTap ? Color("followButtonColorActive") : Color.blue)
        .cornerRadius(5)
    }
}

struct UIComponents_Previews: PreviewProvider {
    static var previews: some View {
        DaoPictureView(daoImage: URL(string: ""), imageSize: 50)
        UserPictureView(userImage: URL(string: ""), imageSize: 15)
        FollowButtonView(buttonWidth: 150, buttonHeight: 35)
    }
}

extension Color {
    static var primary = Color("Primary")
    static var onPrimary = Color("On Primary")
    static var primaryDim = Color("Primary Dim")
    static var secondaryContainer = Color("Secondary Container")
    static var onSecondaryContainer = Color("On Secondary Container")

    static var danger = Color("Danger")
    static var warning = Color("Warning")
    static var success = Color("Success")
    static var fail = Color("Fail")

    static var textWhite = Color("Text White")
    static var textWhite60 = Color("Text White 60%")
    static var textWhite40 = Color("Text White 40%")
    static var textWhite20 = Color("Text White 20%")

    static var surface = Color("Surface")
    static var surfaceBright = Color("Surface Bright")
    static var container = Color("Container")
    static var containerDim = Color("Container Dim")
    static var containerBright = Color("Container Bright")
    
    
    static var goverlandInboxHeaderBackground: Color { return .surfaceBright }
    static var goverlandInboxContentBackground: Color { return .surface }
    static var goverlandInboxItemBackground: Color { return .container }
    static var goverlandInboxListItemUserName: Color { return .textWhite }
    static var goverlandStatusPillActiveVoteBackground: Color { return .primary }
    static var goverlandStatusPillQueuedBackground: Color { return .warning }
    static var goverlandStatusPillSucceededBackground: Color { return .success }
    static var goverlandStatusPillExecutedBackground: Color { return .success }
    static var goverlandStatusPillDefeatedBackground: Color { return .danger }
    static var goverlandStatusPillFailedBackground: Color { return .fail }
    static var goverlandStatusPillVotedBackground: Color { return .success }
    static var goverlandStatusPillActiveVoteText: Color { return .onPrimary }
    static var goverlandStatusPillQueuedText: Color { return .textWhite }
    static var goverlandStatusPillSucceededText: Color { return .textWhite }
    static var goverlandStatusPillExecutedText: Color { return .textWhite }
    static var goverlandStatusPillDefeatedText: Color { return .textWhite }
    static var goverlandStatusPillFailedText: Color { return .textWhite }
    static var goverlandStatusPillVotedText: Color { return .textWhite }
    static var goverlandInboxListItemTitleText: Color { return .textWhite }
    static var goverlandInboxListItemSubtitleText: Color { return .textWhite40 }
    static var goverlandInboxListItemWarningText: Color { return .textWhite40 }
    static var goverlandInboxListItemReadIndicator: Color { return .primary }
}

