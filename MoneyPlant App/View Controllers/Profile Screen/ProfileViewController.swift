//
//  ProfileViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 16/12/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, ProfileUpdateDelegate {

    struct Profile {
        var name: String
    }
    
    var profileCells = [
        Profile(name: "Account"),
        Profile(name: "Settings"),
        Profile(name: "Help & Support"),
        Profile(name: "Log Out")
    ]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var accLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        // Load profile name from UserDefaults
        nameLabel.text = UserDefaults.standard.string(forKey: "profileName") ?? "LogIn Or SignUp"
        
        // Load profile image from UserDefaults
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        updateEmailLabel()
    }
    
    func updateEmailLabel() {
            if let userEmail = Auth.auth().currentUser?.email {
                accLabel.text = userEmail
            } else {
                accLabel.text = "Not User Found"
            }
        }
    
   
    func didUpdateProfile(firstName: String, lastName: String, dob: String, phone: String, profileImage: UIImage?) {
        nameLabel.text = "\(firstName) \(lastName)"
        
        if let image = profileImage {
            imageView.image = image
        }
        
        // Save updated data to UserDefaults
        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "profileName")
        
        if let imageData = profileImage?.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfileSegue",
           let navController = segue.destination as? UINavigationController,
           let destinationVC = navController.topViewController as? editProfileViewController {
            destinationVC.delegate = self
            destinationVC.firstName = nameLabel.text?.components(separatedBy: " ").first ?? ""
            destinationVC.lastName = nameLabel.text?.components(separatedBy: " ").last ?? ""
            destinationVC.profileImage = imageView.image
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        profileCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.cellTitle.text = profileCells[indexPath.section].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // Navigate to Account screen
            let accountVC = storyboard?.instantiateViewController(identifier: "AccountViewController") as! AccountViewController
            navigationController?.present(accountVC, animated: true)
        case 1:
            // Navigate to Settings screen
            let settingsVC = storyboard?.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
            navigationController?.present(settingsVC, animated: true)
        case 2:
            // Navigate to Help & Support screen
            let helpVC = storyboard?.instantiateViewController(identifier: "HelpViewController") as! HelpViewController
            navigationController?.present(helpVC, animated: true)
        case 3:
            // Log out confirmation
            showLogoutConfirmation()
        default:
            break
        }
    }
    func showLogoutConfirmation() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            print("User logged out") // Add logout logic here
            
            // Exit the application
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
                exit(0) // Force quit the app
            }
        }))
        
        present(alert, animated: true)
    }
}
