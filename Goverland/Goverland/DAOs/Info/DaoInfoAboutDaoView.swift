//
//  DaoInfoAboutDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//

import SwiftUI
import MarkdownUI
import SwiftDate

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

    var date: String? {
        return dao.activitySince?.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full)
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
                            openURL(
                                URL(string: "https://twitter.com/\(twitter)") ??
                                URL(string: "https://twitter.com/")!
                            )
                        }
                }

                //TODO: impl once backend return discord
//                if let discord = dao.discord {
//                    Image("dao-info-discord")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: frameH)
//                }
                
                if let coingecko = dao.coingecko {
                    Image("dao-info-coingecko")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH + 4)
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
                        .frame(height: frameH + 4)
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
                        .frame(height: frameH + 4)
                        .onTapGesture {
                            openURL(website)
                        }
                }

                if let snapshotUrl = Utils.urlFromString("https://snapshot.org/#/\(dao.alias)") {
                    Image("dao-info-snapshot")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH + 4)
                        .onTapGesture {
                            openURL(snapshotUrl)
                        }
                }
                
                if let terms = dao.terms {
                    Image("dao-info-terms")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH + 4)
                        .onTapGesture {
                            openURL(terms)
                        }
                }
                
                Spacer()
                
            }

            if let date = date {
                HStack {
                    Text("Activity since \(date)")
                        .font(.footnoteRegular)
                        .foregroundColor(.textWhite60)
                    Spacer()
                }
            }
            
            VStack(alignment: .leading) {
                Markdown(markdownDescription)
                    .markdownTheme(.goverland)
            }
            .padding(.leading, -12)

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
