//
//  SnapshotBasicVotingResultView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
//

import SwiftUI

struct SnapshotBasicVotingResultView: View {
    private let votersData: [Double] = [45.0, 8.5, 2.7]
    private let percentageData: [Double] = [80, 15, 5]
    
    var body: some View {
        VStack {
            ForEach(SnapshotBasicVotingView.ChoiceType.allChoices) { choice in
                let index = choice.rawValue
                SnapshotVotingResultBarView(choice: choice,
                                            votersCount: votersData[index],
                                            choicePercentage: percentageData[index])
                    .padding(.bottom, 30)
            }
            
            SnapshotVotingResultBarView(choice: .for,
                                        votersCount: 54,
                                        choicePercentage: 76)
        }
    }
}

fileprivate struct SnapshotVotingResultBarView: View {
    let choice: SnapshotBasicVotingView.ChoiceType
    let votersCount: Double
    let choicePercentage: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 2) {
                HStack {
                    Text(choice.localizedName)
                        .font(.footnoteSemibold)
                        .foregroundColor(.onSecondaryContainer)
                    Spacer()
                    // TODO: converter to present rounded number with "K" needed here
                    // TODO: converter for %
                    if choice == .for {
                        Text(String(votersCount) + "K / " + String(choicePercentage) + "K")
                            .font(.footnoteSemibold)
                            .foregroundColor(.textWhite)
                    } else {
                        Text(String(votersCount) + "K Voters " + String(choicePercentage) + "%")
                            .font(.footnoteSemibold)
                            .foregroundColor(.textWhite)
                    }
                }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.secondaryContainer)
                        .frame(height: 6, alignment: .center)
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.primary)
                        .frame(width: CGFloat(choicePercentage) * CGFloat(geometry.size.width) / 100, height: 6, alignment: .center)
                }
            }
        }
    }
}

struct SnapshotResultView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotBasicVotingResultView()
    }
}
