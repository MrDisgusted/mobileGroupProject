import UIKit
import FirebaseFirestore
import FirebaseAuth

class ManageProfileViewController: UITableViewController {

    // MARK: - Firebase References
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid

    // MARK: - User Data Model
    var userData: [String: String] = [
        "firstName": "First name",
        "lastName": "Last name",
        "phone": "+11234123412",
        "email": "Email address",
        "country": "Country",
        "address1": "House name / House number",
        "address2": "Street name / Street number",
        "region": "Region / State / Province",
        "postalCode": "0000"
    ]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Profile"
        fetchUserProfile()
    }

    // MARK: - Fetch User Profile from Firebase
    func fetchUserProfile() {
        guard let userId = userId else { return }
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() as? [String: String] {
                self.userData = data
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Personal Information and Address
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure Personal Information Section
        if indexPath.section == 0 {
            let keys = ["firstName", "lastName", "phone", "email"]
            let labels = ["First Name", "Last Name", "Phone No.", "Email"]
            cell.textLabel?.text = labels[indexPath.row]
            cell.detailTextLabel?.text = userData[keys[indexPath.row]]
        }

        // Configure Address Section
        else {
            let keys = ["country", "address1", "address2", "region", "postalCode"]
            let labels = ["Country", "Address 1", "Address 2", "Region", "Postal Code"]
            cell.textLabel?.text = labels[indexPath.row]
            cell.detailTextLabel?.text = userData[keys[indexPath.row]]
        }

        return cell
    }

    // MARK: - Button Action
    @IBAction func proceedButtonTapped(_ sender: UIButton) {
        // Save changes back to Firebase
        saveUserProfile()
    }

    // MARK: - Save User Profile to Firebase
    func saveUserProfile() {
        guard let userId = userId else { return }
        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                print("Error saving user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully.")
            }
        }
    }
}

