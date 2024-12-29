import UIKit
import FirebaseAuth

class MenuTableViewController: UITableViewController {
    
    // MARK: - Menu Items
    let menuItems = [
        "Request a Refund",
        "My Refund Requests",
        "Current Orders",
        "Receipts",
        "Manage Profile",
        "Purchase History",
        "Default Payment Method",
        "Sign Out"
    ]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view background color
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a simple cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MenuCell")
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = menuItems[indexPath.row]
        
        switch selectedItem {
        case "Manage Profile":
            navigateToManageProfile()
        case "Sign Out":
            presentSignOutAlert()
        default:
            print("Feature for \(selectedItem) is not implemented.")
        }
    }
    
    // MARK: - Navigation Methods
    private func navigateToManageProfile() {
        let storyboard = UIStoryboard(name: "ManageProfile", bundle: nil)
        if let manageProfileVC = storyboard.instantiateViewController(withIdentifier: "ManageProfileViewController") as? ManageProfileViewController {
            navigationController?.pushViewController(manageProfileVC, animated: true)
        }
    }
    
    // MARK: - Sign Out Alert
    private func presentSignOutAlert() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.signOutUser()
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch {
            showAlert(title: "Sign Out Failed", message: error.localizedDescription)
        }
    }
    
    private func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "AUTH", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginView")
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
