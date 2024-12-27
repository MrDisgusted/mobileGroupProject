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
        "Default Payment method",
        "Sign out"
    ]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view background color to match the desired color code (#0F0D12)
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0) // #0F0D12
        
        // Register the default cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Single section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count // Number of rows matches menu items
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = menuItems[indexPath.row] // Set menu item text
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.textLabel?.textColor = UIColor.white // Set text color to white
        cell.accessoryType = .disclosureIndicator // Add arrow to indicate navigation
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0) // #0F0D12
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected menu item
        let selectedItem = menuItems[indexPath.row]
        
        if selectedItem == "Sign out" {
            // Show sign out confirmation alert
            presentSignOutAlert()
        } else {
            // Navigate dynamically to the storyboard
            navigateToStoryboard(for: selectedItem)
        }
    }
    
    // MARK: - Dynamic Storyboard Navigation
    func navigateToStoryboard(for item: String) {
        // Convert the menu item to storyboard name format (remove spaces)
        let storyboardName = item.replacingOccurrences(of: " ", with: "")
        
        // Load and navigate to the storyboard's initial view controller
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            navigationController?.pushViewController(initialViewController, animated: true)
        }
    }
    
    // MARK: - Sign Out Alert
    func presentSignOutAlert() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        // "Cancel" action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // "Sign Out" action
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.signOutUser()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Sign Out User
    func signOutUser() {
        do {
            // Firebase sign out
            try Auth.auth().signOut()
            
            // Navigate to the login screen
            navigateToLoginScreen()
        } catch let error {
            // Show error alert if sign out fails
            showAlert(title: "Sign Out Failed", message: error.localizedDescription)
        }
    }
    
    func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        } else {
            showAlert(title: "Navigation Error", message: "Unable to navigate to the login screen.")
        }
    }
    
    // MARK: - Helper Method for Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
