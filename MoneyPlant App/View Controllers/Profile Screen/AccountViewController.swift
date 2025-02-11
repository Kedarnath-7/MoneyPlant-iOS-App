//
//  AccountViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 19/12/24.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let settings = [
            ("Login email", "MoneyPlant123@gmail.com", "edit"),
            ("Password", "••••••••", "edit"),
            ("Two-step verification", "", "switch"),
            ("Connected devices", "1 device", "arrow"),
            ("Delete my account", "", "delete")
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.delegate = self
               tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return settings.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)

           let setting = settings[indexPath.row]
           cell.textLabel?.text = setting.0 // Main Label
           cell.detailTextLabel?.text = setting.1 // Subtitle or Extra Info

           switch setting.2 {
           case "edit":
               cell.accessoryType = .detailButton
           case "switch":
               let switchControl = UISwitch()
               switchControl.isOn = true
               cell.accessoryView = switchControl
           case "arrow":
               cell.accessoryType = .disclosureIndicator
           case "delete":
               cell.textLabel?.textColor = .red
           default:
               break
           }

           return cell
       }
   
}
