//
//  SignUpViewController.swift
//  MoneyPlant App
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleHollowButton(signUpButton)
    }

    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !Utilities.isPasswordValid(cleanedPassword) {
            return "Password must be at least 8 characters, include an uppercase letter, a lowercase letter, and a number."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showError("Please fill in all fields.")
            return
        }
        
        let error = validateFields()
        if error != nil {
            showError(error!)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.handleAuthError(error)
                return
            }
            
            guard let user = result?.user else { return }
            
            // Send Email Verification
            user.sendEmailVerification { error in
                if let error = error {
                    self.showError("Error sending verification email: \(error.localizedDescription)")
                } else {
                    self.showVerificationAlert()
                }
            }
        }
    }
    
    func handleAuthError(_ error: Error) {
        let errorCode = AuthErrorCode(rawValue: error._code)
        switch errorCode {
        case .emailAlreadyInUse:
            showError("This email is already in use. Try logging in.")
        case .weakPassword:
            showError("Your password is too weak. Use a stronger password.")
        case .invalidEmail:
            showError("Invalid email format.")
        default:
            showError(error.localizedDescription)
        }
    }

    func showVerificationAlert() {
        let alert = UIAlertController(title: "Verify Your Email",
                                      message: "A verification email has been sent. Please check your inbox and verify your email before logging in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1.0
    }
}

