//
//  ThemeSelectionViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 03/02/25.
//

import UIKit

class ThemeSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let themes = ["Light", "Dark", "System"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App Appearance"
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath)
        cell.textLabel?.text = themes[indexPath.row]

        // Check selected theme from UserDefaults
        let selectedTheme = UserDefaults.standard.integer(forKey: "selectedTheme")
        cell.accessoryType = (selectedTheme == indexPath.row) ? .checkmark : .none

        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Save selected theme in UserDefaults
        UserDefaults.standard.set(indexPath.row, forKey: "selectedTheme")
        
        // Reload table to update checkmark
        tableView.reloadData()
        
        // Apply selected theme
        applyTheme()
    }
    
    func applyTheme() {
        let selectedTheme = UserDefaults.standard.integer(forKey: "selectedTheme")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch selectedTheme {
                case 0:
                    window.overrideUserInterfaceStyle = .light
                case 1:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }
}
