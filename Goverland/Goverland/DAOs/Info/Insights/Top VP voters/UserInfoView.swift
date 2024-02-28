//
//  UserInfoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-26.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct UserInfoView: View {
    private let voter: TopVoter // will be changed to a 'User' object soon
    
    init(voter: TopVoter) {
        self.voter = voter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(voter.name.value)
                    .font(.title2Regular)
                    .foregroundColor(.textWhite)
                Text("Voting power " + Utils.formattedNumber(voter.votingPower))
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite40)
                Text("Number of votes " + Utils.formattedNumber(voter.votesCount))
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite40)
            }
            .padding(50)
            
            Spacer()
        }
        
        Spacer()
    }
}
