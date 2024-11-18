//
//  loginViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 14/11/24.
//

import UIKit

class loginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let defaultUsername = "arthur morgan".lowercased()
    let defaultEmail = "abcd@gmail.com".lowercased()
    let defaultPassword = "xxxxxxx".lowercased()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        // Get text from fields in lowercase to ensure case-insensitivity
        let enteredEmail = emailField.text?.lowercased() ?? ""
             let enteredPassword = passwordField.text ?? ""
             
             // Validate that email and password fields are not empty
             if enteredEmail.isEmpty || enteredPassword.isEmpty {
                 showAlert(message: "All fields must be filled.")
                 return
             }
             
             // Check if the entered email and password match the default ones
             if enteredEmail == defaultEmail.lowercased() && enteredPassword == defaultPassword {
                 // Navigate to the TabBarController if credentials are correct
                 if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                     tabBarController.selectedIndex = 0
                     view.window?.rootViewController = tabBarController
                     view.window?.makeKeyAndVisible()
                 } else {
                     print("Tab Bar Controller not found.")
                 }
             } else {
                 showAlert(message: "Incorrect Password")
             }
         }
         
         func showAlert(message: String) {
             let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             present(alert, animated: true, completion: nil)
         }
     }
