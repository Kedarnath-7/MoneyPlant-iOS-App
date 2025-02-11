//
//  ReminderSettingsTableTableViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 03/02/25.
//

import UIKit
import UserNotifications

class ReminderSettingsTableTableViewController: UITableViewController {

    @IBOutlet weak var reminderSwitch: UISwitch!

       override func viewDidLoad() {
           super.viewDidLoad()
           setupSwitch()
       }

       private func setupSwitch() {
           UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
               DispatchQueue.main.async {
                   let isReminderEnabled = requests.contains { $0.identifier == "dailyReminder" }
                   self.reminderSwitch.isOn = isReminderEnabled
               }
           }
       }

       @IBAction func reminderSwitchToggled(_ sender: UISwitch) {
           if sender.isOn {
               checkNotificationPermissionAndSchedule()
           } else {
               cancelReminder()
           }
       }

       private func checkNotificationPermissionAndSchedule() {
           let center = UNUserNotificationCenter.current()
           center.getNotificationSettings { settings in
               DispatchQueue.main.async {
                   if settings.authorizationStatus == .authorized {
                       self.scheduleTestReminder()
                   } else {
                       self.reminderSwitch.isOn = false
                       self.showPermissionAlert()
                   }
               }
           }
       }

       private func showPermissionAlert() {
           let alert = UIAlertController(
               title: "Notifications Disabled",
               message: "Please enable notifications in Settings to receive reminders.",
               preferredStyle: .alert
           )
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }

       private func scheduleTestReminder() {
           let center = UNUserNotificationCenter.current()

           let content = UNMutableNotificationContent()
           content.title = "Test Reminder"
           content.body = "This is a test notification every 2 minutes."
           content.sound = .default

           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
           let request = UNNotificationRequest(identifier: "testReminder", content: content, trigger: trigger)

           center.add(request) { error in
               if let error = error {
                   print("Error scheduling test notification: \(error.localizedDescription)")
               } else {
                   print("Test reminder scheduled every 2 minutes")
               }
           }
       }

       private func cancelReminder() {
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["testReminder"])
           print("Test reminder canceled")
       }

    

    // MARK: - Table view data source

   
}
