import UIKit
import FirebaseAuth

class MenuTableViewController: UITableViewController {

    // List of menu items displayed in the table view
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Applying a custom background color to the table view
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Setting the number of rows to match the number of menu items
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configuring each cell with menu item data
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MenuCell")
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        cell.accessoryType = .disclosureIndicator // Adding a disclosure indicator for navigation
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselecting the row to remove the selection highlight
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = menuItems[indexPath.row]
        
        switch selectedItem {
        case "Request a Refund", "My Refund Requests", "Current Orders", "Receipts", "Purchase History", "Default Payment Method":
            // Showing an alert for unavailable features
            showAlert(title: "Unavailable", message: "The selected feature is not available.")
        case "Manage Profile":
            // Navigating to the Manage Profile screen
            navigateToManageProfile()
        case "Sign Out":
            // Displaying a sign-out confirmation alert
            presentSignOutAlert()
        default:
            // Logging unhandled menu items for debugging purposes
            print("Unhandled menu item: \(selectedItem)")
        }
    }
    
    private func navigateToManageProfile() {
        // Navigating to the Manage Profile view controller
        let storyboard = UIStoryboard(name: "ManageProfile", bundle: nil)
        if let manageProfileVC = storyboard.instantiateViewController(withIdentifier: "ManageProfileViewController") as? ManageProfileViewController {
            navigationController?.pushViewController(manageProfileVC, animated: true)
        }
    }
    
    private func presentSignOutAlert() {
        // Creating a confirmation alert for signing out
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) // Cancel option
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            // Signing out the user
            self?.signOutUser()
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func signOutUser() {
        do {
            // Attempting to sign out the user
            try Auth.auth().signOut()
            // Navigating back to the login screen
            navigateToLoginScreen()
        } catch {
            // Showing an alert if sign-out fails
            showAlert(title: "Sign Out Failed", message: error.localizedDescription)
        }
    }
    
    private func navigateToLoginScreen() {
        // Navigating to the login screen after signing out
        let storyboard = UIStoryboard(name: "AUTH", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "Login")
        loginVC.modalPresentationStyle = .fullScreen // Presenting login screen in full screen
        present(loginVC, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        // Displaying a generic alert with the provided title and message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) // OK button to dismiss the alert
        present(alert, animated: true, completion: nil)
    }
}
