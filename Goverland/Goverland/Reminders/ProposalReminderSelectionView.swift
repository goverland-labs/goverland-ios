//
//  ProposalReminderSelectionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftDate

struct ProposalReminderSelectionView: View {
    let proposal: Proposal

    @Environment(\.dismiss) private var dismiss

    @State private var selectedHours: Int?
    @State private var selectedReminderDate: Date?
    @State private var custromReminderDate: Date?
    @State private var showReminderDateSelection = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Add a reminder to vote")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
                .padding(.vertical, 8)

            Spacer()

            ForEach([1, 3, 6, 12, 24, 0], id: \.self) { hours in
                _ReminderButton(hours: hours,
                                endDate: proposal.votingEnd,
                                isSelected: selectedHours == hours,
                                reminderDate: hours == 0 ? custromReminderDate : nil) { hours, date in
                    if hours != 0 {
                        selectedHours = hours
                        selectedReminderDate = date
                    } else {
                        showReminderDateSelection = true
                    }
                }
            }

            HStack {
                SecondaryButton("Cancel") {
                    dismiss()
                }
                PrimaryButton("Add", isEnabled: selectedReminderDate != nil) {
                    addReminder(date: selectedReminderDate!)
                }
            }
            .padding(.top, 12)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, 16)
        .sheet(isPresented: $showReminderDateSelection) {
            _DatePickerView(date: custromReminderDate) { reminderDate in
                selectedReminderDate = reminderDate
                custromReminderDate = reminderDate
                selectedHours = 0
            }
            .presentationDetents([.height(560)])
        }
    }

    private func addReminder(date: Date) {
        Haptic.medium()
        RemindersManager.shared.createVoteReminder(proposal: proposal, reminderDate: date)
        dismiss()
    }
}

fileprivate struct _ReminderButton: View {
    let hours: Int
    let endDate: Date
    let reminderDate: Date?
    let maxWidth: CGFloat
    let height: CGFloat
    let isSelected: Bool
    let action: (Int, Date?) -> Void

    var text: String {
        "Remind \(hours)h before end"
    }

    var isEnabled: Bool {
        if hours == 0 { return true } // custom reminder is always enabled
        return Date.now < reminderDate!
    }

    init(hours: Int,
         endDate: Date,
         isSelected: Bool,
         reminderDate: Date?,
         action: @escaping (Int, Date?) -> Void) {
        self.hours = hours
        self.endDate = endDate
        self.isSelected = isSelected
        if let reminderDate {
            self.reminderDate = reminderDate
        } else if hours != 0 {
            self.reminderDate = Calendar.current.date(byAdding: .hour, value: -hours, to: endDate)!
        } else {
            self.reminderDate = nil
        }
        self.maxWidth = 400
        self.height = 58
        self.action = action
    }

    var body: some View {
        Button(action: {
            action(hours, reminderDate)
        }) {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(Color.secondaryContainer)
                }

                HStack {
                    Spacer()
                    VStack {
                        Text(hours != 0 ? text : "Custom reminder")
                            .font(.bodySemibold)
                        if let reminderDate {
                            Text(Utils.mediumDate(reminderDate))
                                .font(.footnoteRegular)
                        }
                    }
                    Spacer()
                }
            }
            .frame(minWidth: maxWidth * 1/3,
                   maxWidth: maxWidth,
                   minHeight: height,
                   maxHeight: height,
                   alignment: .center)
            .tint(.textWhite)
            .background(
                Capsule()
                    .stroke(Color.secondaryContainer, lineWidth: 1)
            )
            .font(.headlineSemibold)
            .opacity(isEnabled ? 1.0 : 0.3)
        }
        .disabled(!isEnabled)
    }
}

fileprivate struct _DatePickerView: View {
    @State private var date: Date
    var onConfirm: (Date) -> Void

    @Environment(\.dismiss) private var dismiss

    init(date: Date?,
         onConfirm: @escaping (Date) -> Void) {
        if let date {
            self._date = State(wrappedValue: date)
        } else {
            self._date = State(wrappedValue: Date.now + 1.hours)
        }
        self.onConfirm = onConfirm
    }

    var body: some View {
        VStack {
            DatePicker("Select a date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
                .padding()

            Spacer()

            HStack(spacing: 12) {
                SecondaryButton("Cancle") {
                    dismiss()
                }

                PrimaryButton("Confirm") {
                    dismiss()
                    onConfirm(date)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.bottom, 16)
    }
}


#Preview {
    ProposalReminderSelectionView(proposal: .aaveTest)
        .background(Color.container)
}
