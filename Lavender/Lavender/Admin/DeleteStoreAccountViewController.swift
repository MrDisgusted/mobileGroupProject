import UIKit
import FirebaseFirestore

class DeleteStoreAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // Outlet for the table view displaying input fields
    @IBOutlet weak var tableView: UITableView!
    
    // Labels for the input fields
    let fieldLabels = ["store name", "store id", "email"]
    
    // Array to store user-entered values for each field
    var fieldValues = ["", "", ""]
    
    // To prevent duplicate queries
    var isQueryInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the table view appearance and functionality
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        tableView.tableFooterView = UIView() // Remove extra separators
    }
    
    // Number of sections in the table view (one for input fields)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in the table view (equal to the number of fields)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldLabels.count
    }
    
    // Setting up each table view cell with a label and text field
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .clear

        // Creating the label for the field
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 40))
        label.text = fieldLabels[indexPath.row]
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        cell.contentView.addSubview(label)
        
        // Creating the text field for user input
        let textField = UITextField(frame: CGRect(x: 140, y: 5, width: tableView.frame.width - 160, height: 40))
        textField.placeholder = "Enter \(fieldLabels[indexPath.row])"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter \(fieldLabels[indexPath.row])",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.tag = indexPath.row // Use the tag to identify the field
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.text = fieldValues[indexPath.row] // Load saved input
        cell.contentView.addSubview(textField)
        
        return cell
    }
    
    // Updating the `fieldValues` array when the user finishes editing a text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        fieldValues[textField.tag] = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    // Handling the deletion of a store account when the delete button is tapped
    @IBAction func deleteStoreAccountButtonTapped(_ sender: UIButton) {
        // Ensure all text fields are updated
        view.endEditing(true)
        
        // Check if any field is empty
        if fieldValues.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
            showAlert(title: "Error", message: "All fields must be filled.")
            return
        }

        // Prevent duplicate deletion attempts
        guard !isQueryInProgress else { return }
        isQueryInProgress = true

        let storeName = fieldValues[0]
        let storeID = fieldValues[1]
        let email = fieldValues[2]

        // Access Firestore to search for the store account
        let db = Firestore.firestore()
        db.collection("stores")
            .whereField("store name", isEqualTo: storeName)
            .whereField("store id", isEqualTo: storeID)
            .whereField("email", isEqualTo: email)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                self.isQueryInProgress = false // Reset the flag

                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to find store: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    self.showAlert(title: "Error", message: "No matching store account found.")
                    return
                }

                // Proceed to delete the first matched document
                let documentID = documents[0].documentID
                db.collection("stores").document(documentID).delete { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: "Failed to delete store account: \(error.localizedDescription)")
                    } else {
                        self.showAlert(title: "Success", message: "Store account deleted successfully.") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
    }
    
    // Resetting all fields when the discard button is tapped
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        fieldValues = ["", "", ""] // Clear the field values
        tableView.reloadData() // Refresh the table view
    }
    
    // Showing an alert with a title and message, and optional completion action
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
