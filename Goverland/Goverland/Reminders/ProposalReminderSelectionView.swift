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

    @State private var selectedHoursDates = [Int:Date]()
    @State private var showReminderDateSelection = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Add a voting reminder with your selected alerts")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)

            Spacer()

            ForEach([1, 3, 6, 12, 24, 0], id: \.self) { hours in
                _ReminderButton(hours: hours,
                                endDate: proposal.votingEnd,
                                isSelected: selectedHoursDates[hours] != nil,
                                reminderDate: hours == 0 ? selectedHoursDates[0] : nil) { hours, date in
                    if hours != 0 {
                        if selectedHoursDates[hours] == nil {
                            selectedHoursDates[hours] = date
                        } else {
                            selectedHoursDates.removeValue(forKey: hours)
                        }
                    } else {
                        showReminderDateSelection = true
                    }
                }
            }

            HStack {
                SecondaryButton("Cancel") {
                    dismiss()
                }
                PrimaryButton("Add", isEnabled: !selectedHoursDates.isEmpty) {
                    addReminder(dates: selectedHoursDates.values.sorted())
                }
            }
            .padding(.top, 24)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, 16)
        .sheet(isPresented: $showReminderDateSelection) {
            _DatePickerView(date: selectedHoursDates[0]) { reminderDate in
                selectedHoursDates[0] = reminderDate
            }
            .presentationDetents([.height(600)])
        }
    }

    private func addReminder(dates: [Date]) {
        Haptic.medium()
        RemindersManager.shared.createVoteReminders(proposal: proposal, reminderDates: dates)
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
        "Alert \(hours)h before deadline"
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
                        Text(hours != 0 ? text : "Custom alert date")
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
    var onConfirm: (Date?) -> Void

    @Environment(\.dismiss) private var dismiss

    init(date: Date?,
         onConfirm: @escaping (Date?) -> Void) {
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
                SecondaryButton("Clear") {
                    dismiss()
                    onConfirm(nil)
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
