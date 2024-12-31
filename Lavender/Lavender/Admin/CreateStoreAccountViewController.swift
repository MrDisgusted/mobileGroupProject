import UIKit
import FirebaseFirestore

class CreateStoreAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var storeInfoTableView: UITableView! // Table for store information fields
    @IBOutlet weak var accountDetailsTableView: UITableView! // Table for account details fields
    
    let storeInfoFields = ["Store Name", "Owner", "Store ID", "Category"] // Store info labels
    let accountDetailsFields = ["Email", "Password"] // Account details labels
    var storeInfoValues = ["", "", "", ""] // Store info input values
    var accountDetailsValues = ["", ""] // Account details input values
    
    let db = Firestore.firestore() // Firestore database reference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(storeInfoTableView) // Setting up the store info table
        setupTableView(accountDetailsTableView) // Setting up the account details table
    }
    
    func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0) // Dark background
        tableView.tableFooterView = UIView() // Removing extra separators
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Single section for all fields
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == storeInfoTableView ? storeInfoFields.count : accountDetailsFields.count // Rows based on table
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .clear // Clear background for cells
        
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 40)) // Field label
        let textField = UITextField(frame: CGRect(x: 140, y: 5, width: tableView.frame.width - 160, height: 40)) // Text input
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(red: 20/255, green: 18/255, blue: 24/255, alpha: 1.0) // Input field background
        textField.textColor = .white // Text color for input
        textField.delegate = self
        
        if tableView == storeInfoTableView {
            label.text = storeInfoFields[indexPath.row]
            textField.placeholder = "Enter \(storeInfoFields[indexPath.row])"
            textField.tag = indexPath.row // Tagging for store info
            textField.text = storeInfoValues[indexPath.row]
        } else {
            label.text = accountDetailsFields[indexPath.row]
            textField.placeholder = "Enter \(accountDetailsFields[indexPath.row])"
            textField.tag = 100 + indexPath.row // Tagging for account details
            textField.text = accountDetailsValues[indexPath.row]
        }
        
        label.textColor = .white // Label text color
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray] // Placeholder color
        )
        
        textField.autocapitalizationType = .none // Disabling capitalization
        textField.autocorrectionType = .no // Disabling autocorrection
        
        cell.contentView.addSubview(label) // Adding label to the cell
        cell.contentView.addSubview(textField) // Adding text field to the cell
        
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Saving the input to the respective array
        if textField.tag < 100 {
            storeInfoValues[textField.tag] = textField.text ?? ""
        } else {
            let index = textField.tag - 100
            accountDetailsValues[index] = textField.text ?? ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Capturing the latest input values
        storeInfoTableView.visibleCells.forEach { cell in
            if let textField = cell.contentView.subviews.compactMap({ $0 as? UITextField }).first {
                storeInfoValues[textField.tag] = textField.text ?? ""
            }
        }
        accountDetailsTableView.visibleCells.forEach { cell in
            if let textField = cell.contentView.subviews.compactMap({ $0 as? UITextField }).first {
                let index = textField.tag - 100
                accountDetailsValues[index] = textField.text ?? ""
            }
        }
        
        // Combining all input fields for validation
        let allFieldValues = storeInfoValues + accountDetailsValues
        
        if allFieldValues.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
            showAlert(title: "Error", message: "All fields must be filled.") // Showing error if fields are empty
            return
        }
        
        // Preparing data to save in Firestore
        let storeData: [String: Any] = [
            "store name": storeInfoValues[0],
            "owner": storeInfoValues[1],
            "store id": storeInfoValues[2],
            "category": storeInfoValues[3],
            "email": accountDetailsValues[0],
            "password": accountDetailsValues[1],
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        // Saving data to Firestore
        db.collection("stores").document(storeInfoValues[2]).setData(storeData) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to save data: \(error.localizedDescription)")
                return
            }
            self?.showAlert(title: "Success", message: "Store account created successfully.") {
                self?.navigationController?.popViewController(animated: true) // Returning to previous screen
            }
        }
    }
    
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        // Clearing input fields
        storeInfoValues = ["", "", "", ""]
        accountDetailsValues = ["", ""]
        storeInfoTableView.reloadData()
        accountDetailsTableView.reloadData()
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        // Displaying an alert with a completion handler
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
