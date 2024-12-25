import UIKit
import Firebase
import FirebaseAuth

class AdminMenuViewController: UITableViewController {
    
    // MARK: - Menu Items
    let menuItems = [
        "Create a Store Account",
        "Delete a Store Account",
        "Manage Stores",
        "Add Store category in creation + cancel pending...",
        "Pending Tickets",
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
        case "Add Store category in creation + cancel pending...":
            navigateToAddCategory()
        case "Pending Tickets":
            navigateToPendingTickets()
        case "Sign Out":
            signOut()
        default:
            break
        }
    }
    
    // MARK: - Navigation Methods
    func navigateToCreateStoreAccount() {
        // Navigate to Create Store Account screen
        print("Navigating to Create Store Account")
    }
    
    func navigateToDeleteStoreAccount() {
        // Navigate to Delete Store Account screen
        print("Navigating to Delete Store Account")
    }
    
    func navigateToManageStores() {
        // Navigate to Manage Stores screen
        print("Navigating to Manage Stores")
    }
    
    func navigateToAddCategory() {
        // Navigate to Add Store Category screen
        print("Navigating to Add Store Category")
    }
    
    func navigateToPendingTickets() {
        // Navigate to Pending Tickets screen
        print("Navigating to Pending Tickets")
    }
    
    func signOut() {
        // Sign out from Firebase
        do {
            try Auth.auth().signOut()
            print("Signed out successfully")
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

