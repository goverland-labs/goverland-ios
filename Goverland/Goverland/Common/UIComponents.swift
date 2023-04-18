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
    public static var primary: Color { return Color(UIColor(red: 172/255, green: 244/255, blue: 161/255, alpha: 1.0)) }
    public static var onPrimary: Color { return Color(UIColor(red: 0/255, green: 57/255, blue: 7/255, alpha: 1.0)) }
    public static var primaryDim: Color { return Color(UIColor(red: 145/255, green: 216/255, blue: 136/255, alpha: 1.0)) }
    public static var secondaryContainer: Color { return Color(UIColor(red: 57/255, green: 75/255, blue: 58/255, alpha: 1.0)) }
    public static var onSecondaryContainer: Color { return Color(UIColor(red: 211/255, green: 232/255, blue: 209/255, alpha: 1.0)) }
    public static var danger: Color { return Color(UIColor(red: 136/255, green: 15/255, blue: 7/255, alpha: 1.0)) }
    public static var warning: Color { return Color(UIColor(red: 183/255, green: 121/255, blue: 0/255, alpha: 1.0)) }
    public static var success: Color { return Color(UIColor(red: 36/255, green: 89/255, blue: 51/255, alpha: 1.0)) }
    public static var fail: Color { return Color(UIColor(red: 19/255, green: 25/255, blue: 21/255, alpha: 1.0)) }
    public static var textWhite: Color { return Color(UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)) }
    public static var textWhite60: Color { return Color(UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 0.6)) }
    public static var textWhite40: Color { return Color(UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 0.4)) }
    public static var textWhite20: Color { return Color(UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 0.2)) }
    public static var surface: Color { return Color(UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)) }
    public static var surfaceBright: Color { return Color(UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)) }
    public static var container: Color { return Color(UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)) }
    public static var containerDim: Color { return Color(UIColor(red: 4/255, green: 4/255, blue: 4/255, alpha: 1))}
    public static var containerBright: Color { return Color(UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)) }
    
    
    public static var goverlandInboxHeaderBackground: Color { return .surfaceBright }
    public static var goverlandInboxContentBackground: Color { return .surface }
    public static var goverlandInboxItemBackground: Color { return .container }
    public static var goverlandInboxListItemUserName: Color { return .textWhite }
    public static var goverlandStatusPillActiveVoteBackground: Color { return .primary }
    public static var goverlandStatusPillQueuedBackground: Color { return .warning }
    public static var goverlandStatusPillSucceededBackground: Color { return .success }
    public static var goverlandStatusPillExecutedBackground: Color { return .success }
    public static var goverlandStatusPillDefeatedBackground: Color { return .danger }
    public static var goverlandStatusPillFailedBackground: Color { return .fail }
    public static var goverlandStatusPillVotedBackground: Color { return .success }
    public static var goverlandStatusPillActiveVoteText: Color { return .onPrimary }
    public static var goverlandStatusPillQueuedText: Color { return .textWhite }
    public static var goverlandStatusPillSucceededText: Color { return .textWhite }
    public static var goverlandStatusPillExecutedText: Color { return .textWhite }
    public static var goverlandStatusPillDefeatedText: Color { return .textWhite }
    public static var goverlandStatusPillFailedText: Color { return .textWhite }
    public static var goverlandStatusPillVotedText: Color { return .textWhite }
    public static var goverlandInboxListItemTitleText: Color { return .textWhite }
    public static var goverlandInboxListItemSubtitleText: Color { return .textWhite40 }
    public static var goverlandInboxListItemWarningText: Color { return .textWhite40 }
    public static var goverlandInboxListItemReadIndicator: Color { return .primary }
}

