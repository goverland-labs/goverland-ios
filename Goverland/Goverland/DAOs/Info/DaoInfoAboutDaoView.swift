//
//  DaoInfoAboutDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import MarkdownUI
import SwiftDate

struct DaoInfoAboutDaoView: View {
    @Environment(\.openURL) var openURL
    let dao: Dao
    private let frameH: CGFloat = 20

    var markdownDescription: String {
        // we always expect to have a markdown text
        return dao.about?.first { $0.type == .markdown }?.body ?? ""
    }

    var date: String? {
        return dao.activitySince?.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(dao.name)
                    .font(.title3Semibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }
            
            HStack(spacing: 16) {
                if let X = dao.X {
                    Image("dao-info-x")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH)
                        .onTapGesture {
                            openURL(
                                URL(string: "https://x.com/\(X)") ??
                                URL(string: "https://x.com/")!
                            )
                            Tracker.track(.daoOpenX)
                        }
                }
                
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
                            Tracker.track(.daoOpenCoingecko)
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
                            Tracker.track(.daoOpenGithub)
                        }
                }
                
                if let website = dao.website {
                    Image("dao-info-website")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH + 4)
                        .onTapGesture {
                            openURL(website)
                            Tracker.track(.daoOpenWebsite)
                        }
                }

                if let snapshotUrl = Utils.urlFromString("https://snapshot.org/#/\(dao.alias)") {
                    Image("dao-info-snapshot")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH + 4)
                        .onTapGesture {
                            openURL(snapshotUrl)
                            Tracker.track(.daoOpenShapshot)
                        }
                }
                
                if let terms = dao.terms {
                    Image("dao-info-terms")
                        .resizable()
                        .scaledToFit()
                        .frame(height: frameH + 4)
                        .onTapGesture {
                            openURL(terms)
                            Tracker.track(.daoOpenTerms)
                        }
                }
                
                Spacer()
                
            }

            if let date = date {
                HStack {
                    Text("First activity \(date)")
                        .font(.footnoteRegular)
                        .foregroundStyle(Color.textWhite60)
                    Spacer()
                }
            }

            if !dao.categories.isEmpty {
                let first = dao.categories.first!.name.lowercased()
                let categories = dao.categories.dropFirst().reduce("#\(first)") { r, c in "\(r) #\(c.name.lowercased())"}
                Text(categories)
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textWhite60)
            }

            VStack(alignment: .leading) {
                Markdown(markdownDescription)
                    .markdownTheme(.goverland)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            Tracker.track(.screenDaoAbout)
        }
    }
}
