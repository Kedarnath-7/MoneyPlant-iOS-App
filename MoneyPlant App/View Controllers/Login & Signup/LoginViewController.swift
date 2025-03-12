//
//  LoginViewController.swift
//  MoneyPlant App
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
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showError("Please fill in all fields.")
            return
        }

        // Attempt login
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.handleAuthError(error)
                return
            }

            guard let user = result?.user else { return }
            
            if !user.isEmailVerified {
                self.showEmailVerificationAlert(for: user)
                return
            }

            print("Logged in successfully: \(user.email ?? "No Email")")
            self.transitionToHome()
        }
    }

    func handleAuthError(_ error: Error) {
        let errorCode = AuthErrorCode(rawValue: error._code)
        switch errorCode {
        case .wrongPassword:
            showError("Incorrect password. Please try again.")
        case .userNotFound:
            showError("No account found with this email.")
        case .userDisabled:
            showError("Your account has been disabled.")
        case .invalidEmail:
            showError("Invalid email format.")
        default:
            showError(error.localizedDescription)
        }
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1.0
    }

    func showEmailVerificationAlert(for user: User) {
        let alert = UIAlertController(title: "Email Not Verified",
                                      message: "Please verify your email to continue. Would you like to resend the verification email?",
                                      preferredStyle: .alert)

        let resendAction = UIAlertAction(title: "Resend Email", style: .default) { _ in
            user.sendEmailVerification { error in
                if let error = error {
                    self.showError("Error sending verification email: \(error.localizedDescription)")
                } else {
                    self.showError("Verification email sent. Please check your inbox.")
                }
            }
        }
        
        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(resendAction)
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }

    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            // Set the root view controller of the window
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }

}

