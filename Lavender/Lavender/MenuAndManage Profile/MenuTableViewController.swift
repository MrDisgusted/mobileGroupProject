import UIKit

class MenuTableViewController: UITableViewController {
    
    // MARK: - Menu Items
    let menuItems = [
        "Request a Refund",
        "My Refund Requests",
        "Current Orders",
        "Receipts",
        "Sign in as Store Owner",
        "Sign in as Admin",
        "Manage Profile",
        "Purchase History",
        "Default Payment method",
        "Sign out"
    ]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navigation title
        self.title = "Menu"
        
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
        cell.accessoryType = .disclosureIndicator // Add arrow to indicate navigation
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected menu item
        let selectedItem = menuItems[indexPath.row]
        print("Selected: \(selectedItem)")
        
        // Handle menu action
        handleMenuAction(for: selectedItem)
    }
    
    // MARK: - Menu Actions
    func handleMenuAction(for item: String) {
        // Placeholder action - Show an alert
        let alert = UIAlertController(
            title: item,
            message: "You selected \(item). Implement functionality here.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
