import UIKit

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
        
        // Navigate based on the selected item
        performSegue(for: selectedItem)
    }
    
    // MARK: - Navigation via Segues
    func performSegue(for item: String) {
        switch item {
        case "Request a Refund":
            performSegue(withIdentifier: "RequestRefundSegue", sender: self)
        case "My Refund Requests":
            performSegue(withIdentifier: "RefundRequestsSegue", sender: self)
        case "Current Orders":
            performSegue(withIdentifier: "CurrentOrdersSegue", sender: self)
        case "Receipts":
            performSegue(withIdentifier: "ReceiptsSegue", sender: self)
        case "Manage Profile":
            performSegue(withIdentifier: "ManageProfileSegue", sender: self)
        case "Purchase History":
            performSegue(withIdentifier: "PurchaseHistorySegue", sender: self)
        case "Default Payment method":
            performSegue(withIdentifier: "PaymentMethodSegue", sender: self)
        case "Sign out":
            performSegue(withIdentifier: "SignOutSegue", sender: self)
        default:
            break
        }
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Customize navigation to the destination view controller if needed
        // Example:
        // if segue.identifier == "RequestRefundSegue" {
        //     let destinationVC = segue.destination as? RequestRefundViewController
        //     destinationVC.someProperty = someValue
        // }
    }
}

