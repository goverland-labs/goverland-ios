//
//  DelegateVotingPowerSplitView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DelegateVotingPowerSplitView: View {
    @State private var delegates: [Int: (User, Int)] = [0: (User.aaveChan, 1),
                                                           1: (User.flipside, 3)]
    
    @State private var timer: Timer?
    @State private var isTooltipVisible = false
    
    private var sortedDelegates: [(key: Int, value: (User, Int))] {
        delegates.sorted { $0.key < $1.key }
    }
    private var totalAssignedPower: Int {
        delegates.values.reduce(0) { $0 + $1.1 }
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
                            .background(element.value.1 == 0 ? Color.clear : Color.secondaryContainer)
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
                        
                        Text(String(element.value.1))
                            .frame(width: 20)
                        
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(element.value.1 == 0 ? Color.clear : Color.secondaryContainer)
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
                .background(element.value.1 == 0 ? Color.clear : Color.secondaryContainer)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondaryContainer, lineWidth: 1)
                )
            }
            
            HStack {
                 HStack {
                    Text("Keep for yourself")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    
                    Image(systemName: "questionmark.circle")
                        .foregroundStyle(Color.textWhite40)
                        .padding(.trailing)
                        .tooltip($isTooltipVisible, side: .topRight, width: 200) {
                            Text("Keep for yourself")
                                .foregroundStyle(Color.textWhite60)
                                .font(.сaptionRegular)
                        }
                        .onTapGesture() {
                            withAnimation {
                                isTooltipVisible.toggle()
                                // Show tooltip for 5 sec only
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                    if isTooltipVisible {
                                        isTooltipVisible.toggle()
                                    }
                                }
                            }
                        }
                }
                Spacer()
            }
        }
    }
    
    private func increaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 + 1
            delegates[index] = (delegate.0, newPower)
            
        }
    }
    
    private func decreaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 - 1
            if newPower >= 0 {
                delegates[index] = (delegate.0, newPower)
            }
        }
    }
    
    private func percentage(for index: Int) -> String {
        guard totalAssignedPower > 0, let delegateValue = delegates[index]?.1 else { return "0" }
        return Utils.percentage(of: delegateValue, in: totalAssignedPower)
    }
}
