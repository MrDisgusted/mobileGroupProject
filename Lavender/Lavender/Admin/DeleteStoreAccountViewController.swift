import UIKit
import FirebaseAuth
import FirebaseFirestore

class DeleteStoreAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data Source for Table View
    let fieldLabels = ["Store Name", "Store ID", "Email"]
    var fieldValues = ["", "", ""] // To store the entered values dynamically

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // Remove extra separators
    }
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Single section for fields
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        // Create the label
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 40))
        label.text = fieldLabels[indexPath.row]
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.contentView.addSubview(label)
        
        // Create the text field
        let textField = UITextField(frame: CGRect(x: 140, y: 5, width: tableView.frame.width - 160, height: 40))
        textField.placeholder = "Enter \(fieldLabels[indexPath.row])"
        textField.borderStyle = .roundedRect
        textField.tag = indexPath.row // Use tag to identify the field
        textField.delegate = self
        cell.contentView.addSubview(textField)
        
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Store the entered value in the fieldValues array
        fieldValues[textField.tag] = textField.text ?? ""
    }
    
    // MARK: - Delete Store Account Action
    @IBAction func deleteStoreAccountButtonTapped(_ sender: UIButton) {
        let storeName = fieldValues[0]
        let storeID = fieldValues[1]
        let email = fieldValues[2]
        
        // Validate fields
        guard !storeName.isEmpty, !storeID.isEmpty, !email.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        // Access Firebase Firestore
        let db = Firestore.firestore()
        
        // Search for the store account in the "stores" collection
        db.collection("stores")
            .whereField("storeName", isEqualTo: storeName)
            .whereField("storeID", isEqualTo: storeID)
            .whereField("email", isEqualTo: email)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to find store: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, documents.count > 0 else {
                    self.showAlert(title: "Error", message: "No matching store account found.")
                    return
                }
                
                // Delete the store account document
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
    
    // MARK: - Discard Action
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        // Clear all stored values
        fieldValues = ["", "", ""]
        
        // Reload table view to clear text fields
        tableView.reloadData()
    }
    
    // MARK: - Helper Methods
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
