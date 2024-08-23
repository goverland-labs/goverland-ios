//
//  RemindersManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import EventKit
import SwiftUI
import SwiftDate

class RemindersManager {
    private let eventStore = EKEventStore()

    static let shared = RemindersManager()

    private init() {}

    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestFullAccessToReminders { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func createVoteReminders(proposal: Proposal, reminderDates: [Date]) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = "\(proposal.title)"
        reminder.notes = proposal.goverlandLink.absoluteString
        reminder.priority = 1  // 1..4 is a High priority

        // One reminder will be created with the earliest date.
        // Push alerts will appear for each date until the system reminder is marked as completed.
        reminderDates.forEach { date in
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
        }

        let calendar = eventStore.defaultCalendarForNewReminders()
        reminder.calendar = calendar

        do {
            try eventStore.save(reminder, commit: true)
            showToast("Reminder is added")
        } catch {
            logError(GError.failedToCreateReminderToVote)
        }
    }

    static func accessRequiredAlert() -> Alert {
        Alert(title: Text("Access denied"),
              message: Text("Please grant access to Reminders in settings"),
              primaryButton: .default(Text("Open Settings"), action: Utils.openAppSettings),
              secondaryButton: .cancel())
    }
}
