import UIKit
import FirebaseAuth

class AdminMenuViewController: UITableViewController {

    // List of menu items for the admin menu
    let menuItems = [
        "Create Store Account",
        "Delete Store Account",
        "Manage Stores",
        "Sign Out"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the screen title for the navigation bar
        self.title = "Admin Menu"
        
        // Applying a custom background color to the table view
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        
        // Registering the default UITableViewCell class for reuse
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdminMenuCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returning the total number of menu items
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating and configuring a table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminMenuCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselecting the tapped cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Handling the selection based on the menu item
        let selectedItem = menuItems[indexPath.row]
        switch selectedItem {
        case "Create Store Account":
            performSegue(withIdentifier: "CreateStoreAccountSegue", sender: self)
        case "Delete Store Account":
            performSegue(withIdentifier: "DeleteStoreAccountSegue", sender: self)
        case "Manage Stores":
            performSegue(withIdentifier: "ManageStoresSegue", sender: self)
        case "Sign Out":
            presentSignOutAlert()
        default:
            print("Feature for \(selectedItem) is not implemented.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Setting the title of the destination view controller based on the segue
        if segue.identifier == "CreateStoreAccountSegue",
           let destinationVC = segue.destination as? CreateStoreAccountViewController {
            destinationVC.title = "Create Store Account"
        } else if segue.identifier == "DeleteStoreAccountSegue",
                  let destinationVC = segue.destination as? DeleteStoreAccountViewController {
            destinationVC.title = "Delete Store Account"
        } else if segue.identifier == "ManageStoresSegue",
                  let destinationVC = segue.destination as? ManageStoresViewController {
            destinationVC.title = "Manage Stores"
        }
    }

    private func presentSignOutAlert() {
        // Displaying a confirmation alert for signing out
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
        // Attempting to sign out the user using FirebaseAuth
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch {
            // Showing an error alert if signing out fails
            showAlert(title: "Sign Out Failed", message: error.localizedDescription)
        }
    }

    private func navigateToLoginScreen() {
        // Navigating to the login screen after signing out
        let storyboard = UIStoryboard(name: "AUTH", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }

    private func showAlert(title: String, message: String) {
        // Displaying an alert with a title and message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
