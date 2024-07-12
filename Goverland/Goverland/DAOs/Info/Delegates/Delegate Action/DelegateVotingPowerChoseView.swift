//
//  DelegateVotingPowerChoseView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DelegateVotingPowerChoseView: View {
    @State private var delegates: [Int: (User, Double)] = [0: (User.aaveChan, 11.0),
                                                           1: (User.flipside, 32.0)]
    
    @State private var timer: Timer?
    private let votingPower: Double = 43.0
    private var sortedDelegates: [(key: Int, value: (User, Double))] {
        delegates.sorted { $0.key < $1.key }
    }
    
    var body: some View {
        VStack {
            ForEach(Array(sortedDelegates.enumerated()), id: \.1.key) { (index, element) in
                HStack {
                    IdentityView(user: element.value.0, onTap: nil)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Image(systemName: "minus")
                            .frame(width: 40, height: 40)
                            .background(element.value.1 == 0.0 ? Color.clear : Color.secondaryContainer)
                            .gesture(
                                LongPressGesture(minimumDuration: 0.3)
                                    .onEnded { value in
                                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                            self.decreaseVotingPower(forIndex: index)
                                        }
                                    }
                                    .sequenced(before: DragGesture(minimumDistance: 0)
                                        .onEnded { _ in
                                            self.timer?.invalidate()
                                        }
                                    )
                            )
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded {
                                        self.decreaseVotingPower(forIndex: index)
                                    }
                            )
                        
                        Text(String(format: "%.0f", element.value.1))
                            .frame(width: 20)
                        
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(element.value.1 == 0.0 ? Color.clear : Color.secondaryContainer)
                            .gesture(
                                LongPressGesture(minimumDuration: 0.3)
                                    .onEnded { value in
                                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                            self.increaseVotingPower(forIndex: index)
                                        }
                                    }
                                    .sequenced(before: DragGesture(minimumDistance: 0)
                                        .onEnded { _ in
                                            self.timer?.invalidate()
                                        }
                                    )
                            )
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded {
                                        self.timer?.invalidate()
                                        self.increaseVotingPower(forIndex: index)
                                    }
                            )
                        
                        Text(percentage(for: index))
                            .frame(width: 55)
                    }
                    .font(.footnoteSemibold)
                    .foregroundColor(.onSecondaryContainer)
                }
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                .padding(.horizontal)
                .background(element.value.1 == 0.0 ? Color.clear : Color.secondaryContainer)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondaryContainer, lineWidth: 1)
                )
            }
        }
    }
    
    private func increaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 + 1.0
            let totalPower = getTotalVotingPower()
            
            if totalPower + (newPower - delegate.1) <= votingPower {
                delegates[index] = (delegate.0, newPower)
            } else {
                // TODO: Handle exceeding limit (show an alert)
                print("Exceeds total voting power limit!")
            }
        }
    }
    
    private func decreaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 - 1.0
            
            if newPower >= 0 {
                delegates[index] = (delegate.0, newPower)
            }
        }
    }
    
    private func getTotalVotingPower() -> Double {
        return delegates.reduce(0.0) { $0 + $1.value.1 }
    }
    
    private func percentage(for index: Int) -> String {
        return Utils.percentage(of: delegates[index]!.1, in: votingPower)
    }
}
