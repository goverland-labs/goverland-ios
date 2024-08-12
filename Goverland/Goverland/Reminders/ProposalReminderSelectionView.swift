//
//  ProposalReminderSelectionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ProposalReminderSelectionView: View {
    let proposal: Proposal

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 8) {
            Text("Add a reminder to vote")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
                .padding(.top, 8)
                .padding(.bottom, 16)

            Spacer()

            ForEach([1, 3, 6, 12, 24], id: \.self) { hours in
                ReminderButton(hours: hours,
                               endDate: proposal.votingEnd) { reminderDate in
                    Haptic.medium()
                    RemindersManager.shared.createVoteReminder(proposal: proposal, reminderDate: reminderDate)
                    dismiss()
                }
            }

            SecondaryButton("Cancel") {
                dismiss()
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

fileprivate struct ReminderButton: View {
    let hours: Int
    let endDate: Date
    let reminderDate: Date
    let maxWidth: CGFloat
    let height: CGFloat
    let action: (Date) -> Void

    var text: String {
        "Remind \(hours)h before end"
    }

    var isEnabled: Bool {
        Date.now < reminderDate
    }

    init(hours: Int,
         endDate: Date,
         action: @escaping (Date) -> Void) {
        self.hours = hours
        self.endDate = endDate
        self.reminderDate = Calendar.current.date(byAdding: .hour, value: -hours, to: endDate)!
        self.maxWidth = 400
        self.height = 60
        self.action = action
    }

    var body: some View {
        Button(action: {
            action(reminderDate)
        }) {
            HStack {
                Spacer()
                VStack {
                    Text(text)
                        .font(.bodySemibold)
                    Text(Utils.mediumDate(reminderDate))
                        .font(.footnoteRegular)
                }
                Spacer()
            }
            .frame(minWidth: maxWidth * 1/3,
                   maxWidth: maxWidth,
                   minHeight: height,
                   maxHeight: height,
                   alignment: .center)
            .tint(.textWhite)
            .background(
                Capsule()
                    .stroke(Color.textWhite, lineWidth: 1)
            )
            .font(.headlineSemibold)
            .opacity(isEnabled ? 1.0 : 0.3)
        }
        .disabled(!isEnabled)
    }
}


#Preview {
    ProposalReminderSelectionView(proposal: .aaveTest)
        .background(Color.container)
}
