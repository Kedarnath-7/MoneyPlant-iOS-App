//
//  SettingsTableViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 22/12/24.
//

import UIKit

class SettingsTableViewController: UITableViewController {


    let sectionTitles = [
           ["Currency Format", "Daily Reminder Notification", "Security Lock", "Backup & Restore", "Reset Data","Theme Selection"],
           ["Region", "Date Format", "Number Format"],
           ["App Version", "Terms & Conditions", "Privacy Policy"]
       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
     
    }
   
    // MARK: - Table view data source
    func showCurrencyFormatScreen() {
        print("Navigate to Currency Format screen")
        performSegue(withIdentifier: "ShowCurrencyFormat", sender: nil)
        // Add navigation or present a view controller here
    }

    func toggleDailyReminder() {
        print("Toggle daily reminder notifications")
        performSegue(withIdentifier: "toggleDailyReminder", sender: nil)
        // Add logic to enable/disable notifications
    }
    func showThemeSelection() {
        print("Theme selection")
        performSegue(withIdentifier: "theme", sender: nil)
      
    }

    func showDefaultSavingGoalScreen() {
        print("Navigate to Default Saving Goal screen")
    }

    func enableSecurityLock() {
        print("Enable security lock functionality")
    }

    func backupAndRestoreData() {
        print("Backup and restore data")
    }

    func confirmResetData() {
        print("Confirm and reset data")
    }

    func showRegionScreen() {
        print("Navigate to Region selection screen")
        performSegue(withIdentifier: "ShowRegoin", sender: nil)
    }

    func showDateFormatOptions() {
        print("Show date format options")
    }

    func showNumberFormatOptions() {
        print("Show number format options")
        performSegue(withIdentifier: "NumberFormat", sender: nil)
    }

    func showAppVersion() {
        print("Display app version")
    }

    func showTermsAndConditions() {
        print("Navigate to Terms & Conditions screen")
    }

    func showPrivacyPolicy() {
        print("Navigate to Privacy Policy screen")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionTitles[section].count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            // Handle navigation or actions based on selected cell
        switch indexPath.section {
           case 0: // App Settings
               switch indexPath.row {
               case 0: // Currency Format
                   showCurrencyFormatScreen()
               case 1: // Daily Reminder Notification
                   toggleDailyReminder()
//               case 2: // Default Saving Goal
//                   showDefaultSavingGoalScreen()
               case 2: // Security Lock
                   enableSecurityLock()
               case 3: // Backup & Restore
                   backupAndRestoreData()
               case 4: // Reset Data
                   confirmResetData()
               case 5: // Theme Selection
                    showThemeSelection()
               default:
                   break
               }
           case 1: // Region & Preferences
               switch indexPath.row {
               case 0: // Region
                   showRegionScreen()
               case 1: // Date Format
                   showDateFormatOptions()
               case 2: // Number Format
                   showNumberFormatOptions()
               default:
                   break
               }
           case 2: // About
               switch indexPath.row {
               case 0: // App Version
                   showAppVersion()
               case 1: // Terms & Conditions
                   showTermsAndConditions()
               case 2: // Privacy Policy
                   showPrivacyPolicy()
               default:
                   break
               }
           default:
               break
           }
       }
    
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
           
           let text = sectionTitles[indexPath.section][indexPath.row]
           cell.textLabel?.text = text
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.accessoryType = .disclosureIndicator
       cell.backgroundColor = .systemGray6
           return cell
       }



}
