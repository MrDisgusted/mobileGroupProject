import UIKit
import FirebaseAuth
import FirebaseFirestore

class ManageProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var personalInfoTableView: UITableView! // Table for personal info fields
    @IBOutlet weak var addressInfoTableView: UITableView! // Table for address info fields

    let personalInfoFields = ["First Name", "Last Name", "Phone No."] // Labels for personal info
    let personalInfoPlaceholders = ["Enter First Name", "Enter Last Name", "Enter Phone Number"] // Placeholders for personal info
    let addressInfoFields = ["Country", "House", "Road", "Block", "Region"] // Labels for address info
    let addressInfoPlaceholders = ["Enter Country", "Enter House", "Enter Road", "Enter Block", "Enter Region"] // Placeholders for address info
    var personalInfoValues = ["", "", ""] // Input values for personal info
    var addressInfoValues = ["", "", "", "", ""] // Input values for address info

    let db = Firestore.firestore() // Firestore database reference
    var userID: String {
        return Auth.auth().currentUser?.uid ?? "defaultUserID" // Get the current user's ID
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply background color to both tables
        personalInfoTableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        addressInfoTableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)

        // Set delegates and data sources for both tables
        personalInfoTableView.delegate = self
        personalInfoTableView.dataSource = self
        addressInfoTableView.delegate = self
        addressInfoTableView.dataSource = self

        // Load user profile data from Firestore
        fetchProfileData()
    }

    func fetchProfileData() {
        db.collection("users").document(userID).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let data = document?.data() {
                // Map Firestore data to input values
                self.personalInfoValues[0] = data["firstName"] as? String ?? ""
                self.personalInfoValues[1] = data["lastName"] as? String ?? ""
                self.personalInfoValues[2] = data["phone"] as? String ?? ""
                self.addressInfoValues[0] = data["country"] as? String ?? ""
                self.addressInfoValues[1] = data["house"] as? String ?? ""
                self.addressInfoValues[2] = data["road"] as? String ?? ""
                self.addressInfoValues[3] = data["block"] as? String ?? ""
                self.addressInfoValues[4] = data["region"] as? String ?? ""

                // Reload the tables to display the data
                self.personalInfoTableView.reloadData()
                self.addressInfoTableView.reloadData()
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        view.endEditing(true) // Close the keyboard to capture all inputs

        // Ensure required fields are not empty
        guard !personalInfoValues[0].isEmpty, !personalInfoValues[1].isEmpty, !personalInfoValues[2].isEmpty else {
            showAlert(title: "Error", message: "First name, last name, and phone are required.")
            return
        }

        // Prepare data for Firestore update
        let profileData: [String: Any] = [
            "firstName": personalInfoValues[0],
            "lastName": personalInfoValues[1],
            "phone": personalInfoValues[2],
            "country": addressInfoValues[0],
            "house": addressInfoValues[1],
            "road": addressInfoValues[2],
            "block": addressInfoValues[3],
            "region": addressInfoValues[4],
            "updatedAt": FieldValue.serverTimestamp()
        ]

        // Save the data to Firestore
        db.collection("users").document(userID).setData(profileData, merge: true) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to save data: \(error.localizedDescription)")
                return
            }
            // Show success message
            self?.showAlert(title: "Success", message: "Profile updated successfully!")
        }
    }

    @IBAction func discardButtonTapped(_ sender: UIButton) {
        fetchProfileData() // Reload the original data
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == personalInfoTableView {
            return personalInfoFields.count // Number of rows in personal info table
        } else if tableView == addressInfoTableView {
            return addressInfoFields.count // Number of rows in address info table
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0) // Dark cell background

        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 40)) // Field label
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        let textField = UITextField(frame: CGRect(x: 140, y: 5, width: tableView.frame.width - 160, height: 40)) // Input field
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self

        if tableView == personalInfoTableView {
            label.text = personalInfoFields[indexPath.row]
            textField.placeholder = personalInfoPlaceholders[indexPath.row]
            textField.text = personalInfoValues[indexPath.row]
            textField.tag = indexPath.row // Unique tag for personal info
        } else if tableView == addressInfoTableView {
            label.text = addressInfoFields[indexPath.row]
            textField.placeholder = addressInfoPlaceholders[indexPath.row]
            textField.text = addressInfoValues[indexPath.row]
            textField.tag = indexPath.row + personalInfoFields.count // Offset tag for address info
        }

        cell.contentView.addSubview(label) // Add label to the cell
        cell.contentView.addSubview(textField) // Add text field to the cell

        return cell
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Save input values to the respective array
        if textField.tag < personalInfoFields.count {
            personalInfoValues[textField.tag] = textField.text ?? ""
        } else {
            let index = textField.tag - personalInfoFields.count
            addressInfoValues[index] = textField.text ?? ""
        }
    }

    func showAlert(title: String, message: String) {
        // Display an alert with a given title and message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
