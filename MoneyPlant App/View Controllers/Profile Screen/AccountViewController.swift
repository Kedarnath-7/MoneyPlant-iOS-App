import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchUserData()
    }
    
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? "Unknown"
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Login email"
            cell.detailTextLabel?.text = userEmail
            cell.accessoryType = .none
        case 1:
            cell.textLabel?.text = "Password"
            cell.detailTextLabel?.text = "••••••••"
            cell.accessoryType = .none
        case 2:
            cell.textLabel?.text = "Delete my account"
            cell.textLabel?.textColor = .red
            cell.detailTextLabel?.text = ""
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 2 {
            showDeleteConfirmation()
        }
    }
    
    func showDeleteConfirmation() {
        let alert = UIAlertController(title: "Delete Account",
                                      message: "Are you sure you want to delete your account? This action cannot be undone.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteAccount()
        }))
        
        present(alert, animated: true)
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
                self.showError(message: "Failed to delete account. Please re-authenticate and try again.")
            } else {
                print("Account deleted successfully.")
                self.showSuccessMessage()
            }
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccessMessage() {
        let alert = UIAlertController(title: "Account Deleted",
                                      message: "Your account has been deleted successfully.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Exit the app after deletion (Optional)
            exit(0)
        }))
        
        present(alert, animated: true)
    }
}

