////
////  ProfileViewController.swift
////  MoneyPlant App
////
////  Created by admin86 on 16/12/24.
////
//
//import UIKit
//
//class ProfileViewController: UIViewController {
//
//    struct Profile{
//        var name: String
//        var symbol: UIImage
//    }
//    
//    var profileCells = [Profile(name: "Account", symbol: UIImage(systemName: "wallet.bifold")!), Profile(name: "Settings", symbol: UIImage(systemName: "gearshape")!), Profile(name: "Help & Support", symbol: UIImage(systemName: "questionmark")!), Profile(name: "Log Out", symbol: UIImage(systemName: "rectangle.portrait.and.arrow.right")!)]
//    
//    
//    @IBOutlet weak var profileTableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    
//
//}
//
//extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        profileCells.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
//        cell.cellImage.image = profileCells[indexPath.section].symbol
//        cell.cellTitle.text = profileCells[indexPath.section].name
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        90
//    }
// `   `
//
//}
//
//  ProfileViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 16/12/24.
//

import UIKit

class ProfileViewController: UIViewController, ProfileUpdateDelegate {

    struct Profile {
        var name: String
        var symbol: UIImage
    }
    
    var profileCells = [
        Profile(name: "Account", symbol: UIImage(systemName: "person")!),
        Profile(name: "Settings", symbol: UIImage(systemName: "gearshape")!),
        Profile(name: "Help & Support", symbol: UIImage(systemName: "questionmark")!),
        Profile(name: "Log Out", symbol: UIImage(systemName: "rectangle.portrait.and.arrow.right")!)
    ]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the table view's data source and delegate
        profileTableView.dataSource = self
        profileTableView.delegate = self
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        nameLabel.text = UserDefaults.standard.string(forKey: "profileName") ?? "Arthur Morgan"
               if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
                   imageView.image = UIImage(data: imageData)
               } else {
                   imageView.image = UIImage(systemName: "person.circle.fill")
               }
        
    }
    
    func didUpdateProfile(firstName: String, lastName: String, dob: String, phone: String, profileImage: UIImage?) {
          // Update the name label with the new first and last name
          nameLabel.text = "\(firstName) \(lastName)"
          
          // Optionally update the profile image if it's received
          if let image = profileImage {
              imageView.image = image
          }
        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "profileName")
               if let imageData = profileImage?.jpegData(compressionQuality: 0.8) {
                   UserDefaults.standard.set(imageData, forKey: "profileImage")
               }
      }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfileSegue" {
            if let navController = segue.destination as? UINavigationController,
               let destinationVC = navController.topViewController as? editProfileViewController {
                destinationVC.delegate = self
                destinationVC.firstName = nameLabel.text?.components(separatedBy: " ").first ?? ""
                destinationVC.lastName = nameLabel.text?.components(separatedBy: " ").last ?? ""
                destinationVC.profileImage = imageView.image
            }
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
        cell.cellImage.image = profileCells[indexPath.section].symbol
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
            navigationController?.pushViewController(accountVC, animated: true)
        case 1:
            // Navigate to Settings screen
            let settingsVC = storyboard?.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
            navigationController?.pushViewController(settingsVC, animated: true)
        case 2:
            // Navigate to Help & Support screen
            let helpVC = storyboard?.instantiateViewController(identifier: "HelpViewController") as! HelpViewController
            navigationController?.pushViewController(helpVC, animated: true)
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
            }))
            present(alert, animated: true)
        }
}
