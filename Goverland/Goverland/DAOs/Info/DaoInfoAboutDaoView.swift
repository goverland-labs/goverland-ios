//
//  DaoInfoAboutDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//

import SwiftUI
import MarkdownUI

struct DaoInfoAboutDaoView: View {
    let dao: Dao

    // TODO: make a proper fix
    var markdownDescription: String {
        // we always expect to have a markdown text
        let rawStr = dao.about?.first { $0.type == .markdown }!.body
        return rawStr?.replacingOccurrences(of: "ipfs://", with: "https://snapshot.mypinata.cloud/ipfs/") ?? ""
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(dao.name.capitalized)
                    .font(.title3Semibold)
                    .foregroundColor(.textWhite)
                Spacer()
            }
            
            HStack(spacing: 15) {
                Image("dao-info-twitter")
                    .resizable()
                    .scaledToFit()
                Image("dao-info-discord")
                    .resizable()
                    .scaledToFit()
                Image("dao-info-snapshot")
                    .resizable()
                    .scaledToFit()
                Image("dao-info-coingecko")
                    .resizable()
                    .scaledToFit()
                Image("dao-info-github")
                    .resizable()
                    .scaledToFit()
                Image("dao-info-website")
                    .resizable()
                    .scaledToFit()
                Image("dao-info-terms")
                    .resizable()
                    .scaledToFit()
                Spacer()
                
            }
            .frame(height: 17)
            
            HStack {
                Text("Activity since \(dao.alias)")
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite60)
                Spacer()
            }
            .padding(.bottom)
            
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
