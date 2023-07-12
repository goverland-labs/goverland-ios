//
//  DaoInfoAboutDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//

import SwiftUI
import MarkdownUI

struct DaoInfoAboutDaoView: View {
    @Environment(\.openURL) var openURL
    let dao: Dao
    private let frameH: CGFloat = 20

    // TODO: make a proper fix
    var markdownDescription: String {
        // we always expect to have a markdown text
        let rawStr = dao.about?.first { $0.type == .markdown }!.body
        return rawStr?.replacingOccurrences(of: "ipfs://", with: "https://snapshot.mypinata.cloud/ipfs/") ?? ""
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(dao.name.capitalized)
                    .font(.title3Semibold)
                    .foregroundColor(.textWhite)
                Spacer()
            }
            
            HStack(spacing: 20) {
                if let twitter = dao.twitter {
                    Image("dao-info-twitter")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH)
                        .onTapGesture {
                            let appURL = URL(string: "twitter://user?screen_name=\(twitter)")!
                            let webURL = URL(string: "https://twitter.com/\(twitter)")!
                            
                            if UIApplication.shared.canOpenURL(appURL as URL) {
                                UIApplication.shared.open(appURL)
                            } else {
                                UIApplication.shared.open(webURL)
                            }
                        }
                }
                //TODO: backend data needed here to accommodate design
//                if let discord = dao.discord {
//                    Image("dao-info-discord")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: frameH)
//                }
//                if let snapshot = dao.snapshot {
//                    Image("dao-info-snapshot")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: frameH)
//                }
                
                if let coingecko = dao.coingecko {
                    Image("dao-info-coingecko")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH)
                        .onTapGesture {
                            openURL(
                                URL(string: "https://www.coingecko.com/en/coins/\(coingecko)") ??
                                URL(string: "https://www.coingecko.com/")!
                            )
                        }
                }
                
                if let github = dao.github {
                    Image("dao-info-github")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH)
                        .onTapGesture {
                            openURL(
                                URL(string: "https://github.com/\(github)") ??
                                URL(string: "https://github.com/")!
                            )
                        }
                }
                
                if let website = dao.website {
                    Image("dao-info-website")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH)
                        .onTapGesture {
                            openURL(website)
                        }
                }
                
                if let terms = dao.terms {
                    Image("dao-info-terms")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH)
                        .onTapGesture {
                            openURL(terms)
                        }
                }
                
                Spacer()
                
            }
            
            HStack {
                //TODO: date format "Activity since 07 July 2018"
                Text("Activity since \(dao.createdAt)")
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite60)
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Markdown(markdownDescription)
                    .markdownTheme(.goverland)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct DaoInfoAboutDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoAboutDaoView(dao: .aave)
    }
}
