//
//  NotificationManager.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 14.07.2022.
//

import NotificationCenter


class NotificationsManager {
    static let shared = NotificationsManager()
    
    /// Start new notifications task
    func start(title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.hour = hour
        dateComponents.minute = minute
           
        // create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // handle any errors.
           }
        }
    }
    
    /// Sets NotificationCenter eneabled
    func setEnabled(_ isEnabled: Bool)  {
        let center =  UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge]) {_,_ in }
    }
    
    /// Stop all notifications task
    func stop() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
