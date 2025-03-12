////
////  ThemeSelectionViewController.swift
////  MoneyPlant App
////
////  Created by admin15 on 03/02/25.
////
//
//import UIKit
//
//class ThemeSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    let themes = ["Light", "Dark", "System"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "App Appearance"
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    // MARK: - Table View Data Source
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return themes.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath)
//        cell.textLabel?.text = themes[indexPath.row]
//
//        // Check selected theme from UserDefaults
//        let selectedTheme = UserDefaults.standard.integer(forKey: "selectedTheme")
//        cell.accessoryType = (selectedTheme == indexPath.row) ? .checkmark : .none
//
//        return cell
//    }
//    
//    // MARK: - Table View Delegate
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        // Save selected theme in UserDefaults
//        UserDefaults.standard.set(indexPath.row, forKey: "selectedTheme")
//        
//        // Reload table to update checkmark
//        tableView.reloadData()
//        
//        // Apply selected theme
//        applyTheme()
//    }
//    
//    func applyTheme() {
//        let selectedTheme = UserDefaults.standard.integer(forKey: "selectedTheme")
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            windowScene.windows.forEach { window in
//                switch selectedTheme {
//                case 0:
//                    window.overrideUserInterfaceStyle = .light
//                case 1:
//                    window.overrideUserInterfaceStyle = .dark
//                default:
//                    window.overrideUserInterfaceStyle = .unspecified
//                }
//            }
//        }
//    }
//}

import UIKit

class ThemeSelectionViewController: UIViewController {
    
    let themeView = UIView()
    let lightButton = UIButton()
    let darkButton = UIButton()
    let systemButton = UIButton()
    
    let lightCheckmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    let darkCheckmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    let systemCheckmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appearance"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupUI()
        applySavedThemeSelection()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Theme Label
        let themeLabel = UILabel()
        themeLabel.text = "Theme"
        themeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeLabel)
        
        // Theme Selection View
        themeView.layer.cornerRadius = 12
        themeView.backgroundColor = .secondarySystemBackground
        themeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeView)
        
        let lightStack = createButtonStack(imageName: "light_mode", text: "Light Mode", button: lightButton, checkmark: lightCheckmark, tag: 0)
        let darkStack = createButtonStack(imageName: "dark_mode", text: "Dark Mode", button: darkButton, checkmark: darkCheckmark, tag: 1)
        let systemStack = createButtonStack(imageName: "system_mode", text: "Default", button: systemButton, checkmark: systemCheckmark, tag: 2)
        
        let stackView = UIStackView(arrangedSubviews: [lightStack, darkStack, systemStack])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        themeView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            themeView.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 10),
            themeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            themeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            themeView.heightAnchor.constraint(equalToConstant: 140),
            
            stackView.topAnchor.constraint(equalTo: themeView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: themeView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: themeView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: themeView.bottomAnchor, constant: -10)
        ])
    }
    
    func createButtonStack(imageName: String, text: String, button: UIButton, checkmark: UIImageView, tag: Int) -> UIStackView {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = tag
        button.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4) // Padding for visibility
        
        // Checkmark Setup
        checkmark.tintColor = .systemBlue
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.isHidden = true // Initially hidden
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [button, checkmark, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        
        // Checkmark Constraints
        checkmark.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkmark.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return stackView
    }
    
    @objc func themeButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0: saveThemePreference(.light)
        case 1: saveThemePreference(.dark)
        case 2: saveThemePreference(.system)
        default: break
        }
        applySavedThemeSelection()
        applyTheme()
    }
    
    func saveThemePreference(_ mode: ThemeMode) {
        UserDefaults.standard.setValue(mode.rawValue, forKey: "selectedTheme")
    }
    
    func getSavedTheme() -> ThemeMode {
        let savedMode = UserDefaults.standard.string(forKey: "selectedTheme") ?? "system"
        return ThemeMode(rawValue: savedMode) ?? .system
    }
    
    func applySavedThemeSelection() {
        let savedTheme = getSavedTheme()
        
        // Hide all checkmarks
        lightCheckmark.isHidden = true
        darkCheckmark.isHidden = true
        systemCheckmark.isHidden = true
        
        // Show selected checkmark
        switch savedTheme {
        case .light:
            lightCheckmark.isHidden = false
        case .dark:
            darkCheckmark.isHidden = false
        case .system:
            systemCheckmark.isHidden = false
        }
    }
    
    func applyTheme() {
        let savedTheme = getSavedTheme()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            switch savedTheme {
            case .light:
                window.overrideUserInterfaceStyle = .light
            case .dark:
                window.overrideUserInterfaceStyle = .dark
            case .system:
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}

// Enum for Theme Modes
enum ThemeMode: String {
    case light, dark, system
}
