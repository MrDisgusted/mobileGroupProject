import UIKit
import FirebaseFirestore

class StoreDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // Outlet for the store name label
    @IBOutlet weak var storeNameLabel: UILabel!
    
    // Outlet for the table view displaying store details
    @IBOutlet weak var tableView: UITableView!

    // Property to store the selected store's ID, set by the previous view controller
    var storeID: String?
    
    // Fields and values for store details
    let fields = ["Store Name", "Owner", "Store ID", "Category", "Email", "Password"]
    var values = ["", "", "", "", "", ""]
    
    // Reference to Firestore
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the table view properties and appearance
        setupTableView()
        
        // Fetching the store details from Firestore
        fetchStoreDetails()
    }

    // Setting the table view's delegate, data source, and appearance
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        tableView.tableFooterView = UIView()
    }

    // Fetching store details from Firestore using the storeID
    private func fetchStoreDetails() {
        guard let storeID = storeID else { return }

        db.collection("stores").document(storeID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching store details: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else { return }

            // Extracting store data and updating the `values` array
            self.values[0] = data["store name"] as? String ?? ""
            self.values[1] = data["owner"] as? String ?? ""
            self.values[2] = data["store id"] as? String ?? ""
            self.values[3] = data["category"] as? String ?? ""
            self.values[4] = data["email"] as? String ?? ""
            self.values[5] = data["password"] as? String ?? ""
            
            // Displaying the store name in the label
            self.storeNameLabel.text = self.values[0]
            
            // Reloading the table view to display fetched data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // Returning the number of fields to display in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }

    // Creating and configuring each cell with field labels and editable text fields
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .clear

        // Adding a label for the field name
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 40))
        label.text = "\(fields[indexPath.row]):"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        cell.contentView.addSubview(label)

        // Adding an editable text field for the field value
        let textField = UITextField(frame: CGRect(x: 140, y: 5, width: tableView.frame.width - 160, height: 40))
        textField.text = values[indexPath.row]
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.delegate = self
        textField.tag = indexPath.row
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter \(fields[indexPath.row])",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        cell.contentView.addSubview(textField)

        return cell
    }

    // Updating the `values` array when editing ends on a text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        values[textField.tag] = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    // Saving updated store details to Firestore
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Forcing all text fields to end editing
        view.endEditing(true)

        guard let storeID = storeID else { return }

        // Checking if any field is empty
        if values.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
            showAlert(title: "Error", message: "All fields must be filled.")
            return
        }

        // Preparing updated data for Firestore
        let updatedData: [String: Any] = [
            "store name": values[0],
            "owner": values[1],
            "store id": values[2],
            "category": values[3],
            "email": values[4],
            "password": values[5]
        ]

        // Updating the store details in Firestore
        db.collection("stores").document(storeID).updateData(updatedData) { error in
            if let error = error {
                print("Error updating store details: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to update store details.")
            } else {
                self.showAlert(title: "Success", message: "Store details updated successfully.")
            }
        }
    }

    // Discarding unsaved changes and reloading original data from Firestore
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        fetchStoreDetails()
    }

    // Displaying an alert message
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
