import UIKit
import FirebaseAuth
import FirebaseFirestore

class ManageProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var personalInfoTableView: UITableView!
    @IBOutlet weak var addressInfoTableView: UITableView!

    // MARK: - Data
    let personalInfoFields = ["First Name", "Last Name", "Phone No."]
    let personalInfoPlaceholders = ["Enter First Name", "Enter Last Name", "Enter Phone Number"]
    let addressInfoFields = ["Country", "House", "Road", "Block", "Region"]
    let addressInfoPlaceholders = ["Enter Country", "Enter House", "Enter Road", "Enter Block", "Enter Region"]
    var personalInfoValues = ["", "", ""]
    var addressInfoValues = ["", "", "", "", ""]

    // MARK: - Firebase References
    let db = Firestore.firestore()
    var userID: String {
        return Auth.auth().currentUser?.uid ?? "defaultUserID"
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up TableView background color
        personalInfoTableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        addressInfoTableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)

        // Set delegates and data sources
        personalInfoTableView.delegate = self
        personalInfoTableView.dataSource = self
        addressInfoTableView.delegate = self
        addressInfoTableView.dataSource = self

        // Clear Firebase cache (optional)
        clearFirestoreCache()

        // Fetch profile data
        prepareForNewUser()
        fetchProfileData()
    }

    // MARK: - Clear Firestore Cache
    func clearFirestoreCache() {
        db.clearPersistence { error in
            if let error = error {
                print("Error clearing Firestore cache: \(error.localizedDescription)")
            } else {
                print("Firestore cache cleared successfully.")
            }
        }
    }

    // MARK: - Prepare for New User
    func prepareForNewUser() {
        // Reset data and reload placeholders
        personalInfoValues = ["", "", ""]
        addressInfoValues = ["", "", "", "", ""]
        personalInfoTableView.reloadData()
        addressInfoTableView.reloadData()
    }

    // MARK: - Fetch Data from Firestore
    func fetchProfileData() {
        db.collection("users").document(userID).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let data = document?.data() {
                self.personalInfoValues[0] = data["firstName"] as? String ?? ""
                self.personalInfoValues[1] = data["lastName"] as? String ?? ""
                self.personalInfoValues[2] = data["phone"] as? String ?? ""
                self.addressInfoValues[0] = data["country"] as? String ?? ""
                self.addressInfoValues[1] = data["house"] as? String ?? ""
                self.addressInfoValues[2] = data["road"] as? String ?? ""
                self.addressInfoValues[3] = data["block"] as? String ?? ""
                self.addressInfoValues[4] = data["region"] as? String ?? ""

                // Reload table views
                self.personalInfoTableView.reloadData()
                self.addressInfoTableView.reloadData()
            }
        }
    }

    // MARK: - Save Button Action
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard !personalInfoValues[0].isEmpty, !personalInfoValues[1].isEmpty, !personalInfoValues[2].isEmpty else {
            showAlert(title: "Error", message: "First name, last name, and phone are required.")
            return
        }

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

        db.collection("users").document(userID).setData(profileData, merge: true) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to save data: \(error.localizedDescription)")
                return
            }

            self?.showAlert(title: "Success", message: "Profile updated successfully!")
        }
    }

    // MARK: - Discard Button Action
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        // Clear all input fields
        prepareForNewUser()

        // Reload the original user collection data
        fetchProfileData()
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == personalInfoTableView {
            return personalInfoFields.count
        } else if tableView == addressInfoTableView {
            return addressInfoFields.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil) // Use `.value1` for better layout
        cell.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0)
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold) // Larger and bolder font for the field names
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18) // Larger font for the values

        if tableView == personalInfoTableView {
            cell.textLabel?.text = personalInfoFields[indexPath.row]
            cell.detailTextLabel?.text = personalInfoValues[indexPath.row].isEmpty
                ? personalInfoPlaceholders[indexPath.row] // Show placeholder if value is empty
                : personalInfoValues[indexPath.row]
        } else if tableView == addressInfoTableView {
            cell.textLabel?.text = addressInfoFields[indexPath.row]
            cell.detailTextLabel?.text = addressInfoValues[indexPath.row].isEmpty
                ? addressInfoPlaceholders[indexPath.row] // Show placeholder if value is empty
                : addressInfoValues[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let fieldName: String
        let currentValue: String
        let placeholder: String
        if tableView == personalInfoTableView {
            fieldName = personalInfoFields[indexPath.row]
            currentValue = personalInfoValues[indexPath.row]
            placeholder = personalInfoPlaceholders[indexPath.row]
        } else {
            fieldName = addressInfoFields[indexPath.row]
            currentValue = addressInfoValues[indexPath.row]
            placeholder = addressInfoPlaceholders[indexPath.row]
        }

        let alert = UIAlertController(title: "Edit \(fieldName)", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = currentValue.isEmpty ? placeholder : currentValue
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let newValue = alert.textFields?.first?.text ?? ""
            if tableView == self.personalInfoTableView {
                self.personalInfoValues[indexPath.row] = newValue
            } else {
                self.addressInfoValues[indexPath.row] = newValue
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Show Alert Helper
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
