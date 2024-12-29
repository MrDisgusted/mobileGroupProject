import UIKit
import FirebaseFirestore

class CreateStoreAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var storeInfoTableView: UITableView! // First TableView for Store Information
    @IBOutlet weak var accountDetailsTableView: UITableView! // Second TableView for Account Details

    // MARK: - Data
    let storeInfoFields = ["Store", "Owner", "Store ID", "Category"]
    let accountDetailsFields = ["Email", "Password"]
    var storeInfoValues = ["", "", "", ""]
    var accountDetailsValues = ["", ""]

    // MARK: - Firebase References
    let db = Firestore.firestore()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Safely handle table views
        guard let storeInfoTableView = storeInfoTableView,
              let accountDetailsTableView = accountDetailsTableView else {
            print("Error: One or both table views are not connected.")
            return
        }

        // Set table view delegates and data sources
        storeInfoTableView.delegate = self
        storeInfoTableView.dataSource = self
        accountDetailsTableView.delegate = self
        accountDetailsTableView.dataSource = self

        // Register cells for reuse
        storeInfoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "StoreInfoCell")
        accountDetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountDetailsCell")

        // Set background colors
        storeInfoTableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        accountDetailsTableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
    }

    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Each table view has one section
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the appropriate row count for each table view
        if tableView == storeInfoTableView {
            return storeInfoFields.count
        } else if tableView == accountDetailsTableView {
            return accountDetailsFields.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        if tableView == storeInfoTableView {
            // Configure cell for Store Information
            cell.textLabel?.text = storeInfoFields[indexPath.row]
            cell.detailTextLabel?.text = storeInfoValues[indexPath.row]
        } else if tableView == accountDetailsTableView {
            // Configure cell for Account Details
            cell.textLabel?.text = accountDetailsFields[indexPath.row]
            cell.detailTextLabel?.text = accountDetailsValues[indexPath.row]
        }

        // Set styles
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .gray
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Set the header titles
        if tableView == storeInfoTableView {
            return "Store Information"
        } else if tableView == accountDetailsTableView {
            return "Account Details"
        }
        return nil
    }

    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let fieldName: String
        let currentValue: String

        if tableView == storeInfoTableView {
            fieldName = storeInfoFields[indexPath.row]
            currentValue = storeInfoValues[indexPath.row]
        } else {
            fieldName = accountDetailsFields[indexPath.row]
            currentValue = accountDetailsValues[indexPath.row]
        }

        let alert = UIAlertController(title: "Edit \(fieldName)", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = currentValue
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let newValue = alert.textFields?.first?.text ?? ""
            if tableView == self.storeInfoTableView {
                self.storeInfoValues[indexPath.row] = newValue
            } else {
                self.accountDetailsValues[indexPath.row] = newValue
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Save Button Action
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard !storeInfoValues.contains(""), !accountDetailsValues.contains("") else {
            showAlert(title: "Error", message: "All fields must be filled.")
            return
        }

        let storeData: [String: Any] = [
            "store": storeInfoValues[0],
            "owner": storeInfoValues[1],
            "storeID": storeInfoValues[2],
            "category": storeInfoValues[3],
            "email": accountDetailsValues[0],
            "password": accountDetailsValues[1],
            "createdAt": FieldValue.serverTimestamp()
        ]

        db.collection("stores").document(storeInfoValues[2]).setData(storeData) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to save data: \(error.localizedDescription)")
                return
            }
            self?.showAlert(title: "Success", message: "Store account created successfully!")
        }
    }

    // MARK: - Discard Button Action
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        storeInfoValues = ["", "", "", ""]
        accountDetailsValues = ["", ""]
        storeInfoTableView.reloadData()
        accountDetailsTableView.reloadData()
    }

    // MARK: - Helper Method to Show Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
