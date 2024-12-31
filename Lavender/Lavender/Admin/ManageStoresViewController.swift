import UIKit
import FirebaseFirestore

class ManageStoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlet for the table view displaying store data
    @IBOutlet weak var tableView: UITableView!

    // Firestore reference and array to hold store data
    let db = Firestore.firestore()
    var stores: [[String: String]] = [] // Array of dictionaries for store details

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the screen title for the navigation bar
        self.title = "Manage Stores"
        
        // Setting up the table view with delegate, data source, and appearance
        setupTableView()
        
        // Fetching store data from Firestore
        fetchStores()
    }

    // Setting the table view's delegate, data source, and background appearance
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StoreCell")
    }

    // Fetching store details from Firestore and storing them in the `stores` array
    private func fetchStores() {
        db.collection("stores").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching stores: \(error.localizedDescription)")
                return
            }

            // Safely accessing documents from the Firestore snapshot
            guard let documents = snapshot?.documents else { return }

            // Mapping Firestore documents to a dictionary array
            self.stores = documents.map { document in
                let data = document.data()
                return [
                    "storeName": data["store name"] as? String ?? "Unknown Store",
                    "email": data["email"] as? String ?? "Unknown Email",
                    "storeID": data["store id"] as? String ?? "Unknown Store ID"
                ]
            }
            
            // Reloading the table view on the main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // Returning the number of stores for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }

    // Configuring each table view cell with store name and email
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StoreCell")
        let store = stores[indexPath.row]
        
        // Applying the store name as the main text
        cell.textLabel?.text = store["storeName"]
        
        // Applying the email as the subtitle
        cell.detailTextLabel?.text = store["email"]
        
        // Customizing text appearance for the cell
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        // Setting the cell's background color to match the table
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        
        return cell
    }

    // Handling cell selection to navigate to the store details view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = stores[indexPath.row]
        
        // Triggering the segue with the selected store as the sender
        performSegue(withIdentifier: "ShowStoreDetails", sender: store)
    }

    // Preparing the destination view controller by passing the store ID
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStoreDetails",
           let destinationVC = segue.destination as? StoreDetailsViewController,
           let store = sender as? [String: String] {
            destinationVC.storeID = store["storeID"] // Passing the store ID to the next screen
        }
    }
}
