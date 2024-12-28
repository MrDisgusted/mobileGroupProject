import UIKit
import FirebaseAuth

class AdminMenuViewController: UITableViewController {
    
    // MARK: - Menu Items
    let menuItems = [
        "Create a Store Account",
        "Delete a Store Account",
        "Manage Stores",
        "Sign Out"
    ]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Admin Menu"
        
        // Set the table view background color
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0) // Dark background
        
        // Register the default cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdminMenuCell")
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminMenuCell", for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected menu item
        let selectedItem = menuItems[indexPath.row]
        
        if selectedItem == "Sign Out" {
            presentSignOutAlert()
        } else {
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
        } else {
            showAlert(title: "Navigation Error", message: "Unable to navigate to \(item).")
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
            showAlert(title: "Sign Out Failed", message: error.localizedDescription)
        }
    }
    
    func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "AUTH", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "AdminLoginViewController") as? AdminLoginViewController {
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
