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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdminMenuCell")
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Single section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminMenuCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = menuItems[indexPath.row]
        print("Selected: \(selectedItem)")
        
        switch selectedItem {
        case "Create a Store Account":
            navigateToCreateStoreAccount()
        case "Delete a Store Account":
            navigateToDeleteStoreAccount()
        case "Manage Stores":
            navigateToManageStores()
        case "Sign Out":
            signOut()
        default:
            break
        }
    }
    
    // MARK: - Navigation Methods
    func navigateToCreateStoreAccount() {
        // Navigate to Create Store Account screen
        if let createStoreVC = storyboard?.instantiateViewController(withIdentifier: "CreateStoreAccountViewController") {
            navigationController?.pushViewController(createStoreVC, animated: true)
        }
    }
    
    func navigateToDeleteStoreAccount() {
        // Navigate to Delete Store Account screen
        if let deleteStoreVC = storyboard?.instantiateViewController(withIdentifier: "DeleteStoreAccountViewController") {
            navigationController?.pushViewController(deleteStoreVC, animated: true)
        }
    }
    
    func navigateToManageStores() {
        // Navigate to Manage Stores screen
        if let manageStoresVC = storyboard?.instantiateViewController(withIdentifier: "ManageStoresViewController") {
            navigationController?.pushViewController(manageStoresVC, animated: true)
        }
    }
    
    func signOut() {
        // Sign out from Firebase
        do {
            try Auth.auth().signOut()
            print("Signed out successfully")
            navigateToLoginScreen()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Method for Sign Out Navigation
    func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "AUTH", bundle: nil)
           if let loginVC = storyboard.instantiateViewController(withIdentifier: "AdminLoginViewController") as? AdminLoginViewController {
               loginVC.modalPresentationStyle = .fullScreen
               present(loginVC, animated: true, completion: nil)
        }
    }
}
