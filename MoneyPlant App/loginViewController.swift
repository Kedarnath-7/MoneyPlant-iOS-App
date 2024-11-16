//
//  loginViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 14/11/24.
//

import UIKit

class loginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let defaultUsername = "arthur morgan".lowercased()
    let defaultEmail = "abcd@gmail.com".lowercased()
    let defaultPassword = "xxxxxxx".lowercased()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // Get text from fields in lowercase to ensure case-insensitivity
        let enteredUsername = usernameField.text?.lowercased() ?? ""
        let enteredEmail = emailField.text?.lowercased() ?? ""
        let enteredPassword = passwordField.text?.lowercased() ?? ""
        let enteredConfirmPassword = confirmPasswordField.text?.lowercased() ?? ""
        // Validate the entered values
        if enteredUsername == defaultUsername &&
            enteredEmail == defaultEmail &&
            enteredPassword == defaultPassword &&
            enteredPassword == enteredConfirmPassword {
            
            // Successful signup - navigate to the next view controller
            if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "successfulSignupSegue") {
                navigationController?.pushViewController(nextViewController, animated: true)
            }
        } else {
            // Show error if values do not match
            print("Sign up failed: Invalid credentials or passwords do not match")
        }
    }
}
