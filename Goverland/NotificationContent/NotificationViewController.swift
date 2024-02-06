//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Jenny Shalai on 2024-02-05.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    @IBOutlet var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.title
    }
}
