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
    public static var goverlandGreenPrimary: Color {
        return Color(UIColor(red: 172/255, green: 244/255, blue: 161/255, alpha: 1.0))
    }
    
    public static var goverlandStatusPillActiveVoteBackground: Color {
        return Color(UIColor(red: 172/255, green: 244/255, blue: 161/255, alpha: 1.0))
    }
    public static var goverlandStatusPillQueuedBackground: Color {
        return Color(UIColor(red: 183/255, green: 121/255, blue: 0/255, alpha: 1.0))
    }
    public static var goverlandStatusPillSucceededBackground: Color {
        return Color(UIColor(red: 36/255, green: 89/255, blue: 51/255, alpha: 1.0))
    }
    public static var goverlandStatusPillExecutedBackground: Color {
        return Color(UIColor(red: 36/255, green: 89/255, blue: 51/255, alpha: 1.0))
    }
    public static var goverlandStatusPillDefeatedBackground: Color {
        return Color(UIColor(red: 136/255, green: 15/255, blue: 7/255, alpha: 1.0))
    }
    public static var goverlandStatusPillFailedBackground: Color {
        return Color(UIColor(red: 19/255, green: 26/255, blue: 21/255, alpha: 1.0))
    }

    public static var goverlandStatusPillActiveVoteText: Color {
        return Color(UIColor(red: 0/255, green: 57/255, blue: 7/255, alpha: 1.0))
    }
    public static var goverlandStatusPillQueuedText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 1.0))
    }
    public static var goverlandStatusPillSucceededText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 1.0))
    }
    public static var goverlandStatusPillExecutedText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 1.0))
    }
    public static var goverlandStatusPillDefeatedText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 1.0))
    }
    public static var goverlandStatusPillFailedText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 1.0))
    }
    
    public static var goverlandInboxListItemTitleText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 1.0))
    }
    public static var goverlandInboxListItemSubtitleText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 0.4))
    }
    public static var goverlandInboxListItemWarningText: Color {
        return Color(UIColor(red: 277/255, green: 277/255, blue: 277/255, alpha: 0.4))
    }

    public static var goverlandInboxListItemReadIndicator: Color {
        return Color(UIColor(red: 172/255, green: 244/255, blue: 161/255, alpha: 1))
    }
}

