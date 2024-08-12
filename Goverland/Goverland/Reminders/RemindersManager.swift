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

    func createVoteReminder(proposal: Proposal, reminderDate: Date) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = "Vote on proposal: \(proposal.title)"
        reminder.notes = "https://app.goverland.xyz/proposals/\(proposal.id)"
        reminder.priority = 1  // 1..4 is a High priority

        let alarm = EKAlarm(absoluteDate: reminderDate)
        reminder.addAlarm(alarm)

        let calendar = eventStore.defaultCalendarForNewReminders()
        reminder.calendar = calendar

        do {
            try eventStore.save(reminder, commit: true)
            showToast("Reminder set 4 hours before voting ends")
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
