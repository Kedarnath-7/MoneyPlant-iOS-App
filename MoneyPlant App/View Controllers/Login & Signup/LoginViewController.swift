//
//  LoginViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 15/12/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleHollowButton(loginButton)
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        // Validate text fields
        let error = validateFields()
        
        if error != nil {
            // There is something wrong with the fields, show error message
            showError(error!)
        }else {
            
            // Create the cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Logining the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    // There was an error signing in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1.0
                }else{
                    // Transition to the Home Screen
                    self.transitionToHome()
                }
            }
        }
        
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1.0
    }
    func transitionToHome() {
        let gardenViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.gardenViewController) as? GardenViewController
        
        view.window?.rootViewController = gardenViewController
        view.window?.makeKeyAndVisible()
    }
}
