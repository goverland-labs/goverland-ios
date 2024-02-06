//
//  NotificationService.swift
//  NotificationExtension
//
//  Created by Jenny Shalai on 2024-01-19.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import UserNotifications
import UniformTypeIdentifiers
import MobileCoreServices


class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // custom push notification
        if let bestAttemptContent = bestAttemptContent {
            let data = bestAttemptContent.userInfo as NSDictionary

            if let imageURLString = data["fcm_options"] as? [String: String],
               let attachmentString = imageURLString["image"], 
                let attachmentUrl = URL(string: attachmentString)
            {
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let downloadTask = session.downloadTask(with: attachmentUrl, completionHandler: { url, _, error in
                    if let error = error {
//                        logInfo("[NotificationService] Error: \(error.localizedDescription)")
                        print(error.localizedDescription)
                    } else if let url {
                        if let attachment = try? UNNotificationAttachment(identifier: attachmentString,
                                                                          url: url,
                                                                          options: [UNNotificationAttachmentOptionsTypeHintKey: UTType.png]) {
                            bestAttemptContent.attachments = [attachment]
                        }
                    }
                    contentHandler(bestAttemptContent)
                })
                downloadTask.resume()
            }
        }
//        // paired with GoverlandApp
//        // action controls in expanded custom push notification
//        let action1 = UNNotificationAction(identifier: "action1",
//                                           title: "Action 1",
//                                           options: .foreground)
//        let action2 = UNNotificationAction(identifier: "action2",
//                                           title: "Action 2",
//                                           options: .destructive)
//        
//        let category = UNNotificationCategory(identifier: "myCategory",
//                                              actions: [action1, action2],
//                                              intentIdentifiers: [],
//                                              options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([category])
        bestAttemptContent?.categoryIdentifier = "myCategory"
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
