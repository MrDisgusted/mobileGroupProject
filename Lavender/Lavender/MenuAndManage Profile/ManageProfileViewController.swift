import UIKit
import FirebaseAuth
import FirebaseFirestore

class ManageProfileViewController: UITableViewController {
    
    // MARK: - Outlets for TextFields
    @IBOutlet weak var profileFirstNameTextField: UITextField!
    @IBOutlet weak var profileLastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var profileEmailTextField: UITextField!
    
    // Save Button
    private var saveButton: UIButton!
    
    // MARK: - Firebase Reference
    let db = Firestore.firestore()
    var userID: String {
        return Auth.auth().currentUser?.uid ?? "defaultUserID"
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProfileData() // Load user data from Firebase when the screen loads
    }

    func setupUI() {
        // Configure table view
        tableView.keyboardDismissMode = .onDrag // Dismiss keyboard on scroll
        tableView.backgroundColor = UIColor(red: 15/255, green: 13/255, blue: 18/255, alpha: 1.0) // #0F0D12
        
        // Add Save button programmatically
        setupSaveButton()
    }
    
    func setupSaveButton() {
        // Initialize Save button
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // Add Save button to the table view's superview
        if let parentView = tableView.superview {
            parentView.addSubview(saveButton)
            
            // Add constraints
            NSLayoutConstraint.activate([
                saveButton.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                saveButton.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                saveButton.widthAnchor.constraint(equalToConstant: 120),
                saveButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    // MARK: - Fetch Data from Firebase
    func fetchProfileData() {
        db.collection("users").document(userID).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let data = document?.data() {
                self?.profileFirstNameTextField.text = data["firstName"] as? String
                self?.profileLastNameTextField.text = data["lastName"] as? String
                self?.phoneTextField.text = data["phone"] as? String
                self?.profileEmailTextField.text = data["email"] as? String
            }
        }
    }

    // MARK: - Save Button Action
    @objc func saveButtonTapped() {
        // Validate inputs
        guard let firstName = profileFirstNameTextField.text, !firstName.isEmpty,
              let lastName = profileLastNameTextField.text, !lastName.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let email = profileEmailTextField.text, !email.isEmpty else {
            showAlert("Please fill in all fields before saving.")
            return
        }
        
        // Reference to the current user
        guard let currentUser = Auth.auth().currentUser else {
            showAlert("No user is currently signed in.")
            return
        }
        
        // Check if the email has changed
        if email != currentUser.email {
            let alertController = UIAlertController(
                title: "Change Email",
                message: "Changing your email will sign you out. Are you sure you want to proceed?",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.updateEmailAndSignOut(currentUser, email: email, firstName: firstName, lastName: lastName, phone: phone)
            }))
            present(alertController, animated: true, completion: nil)
        } else {
            // Update only Firestore profile if email hasn't changed
            updateFirestoreProfile(firstName: firstName, lastName: lastName, phone: phone, email: email)
            showAlert("Profile updated successfully!")
        }
    }
    
    func updateEmailAndSignOut(_ user: User, email: String, firstName: String, lastName: String, phone: String) {
        user.updateEmail(to: email) { [weak self] error in
            if let error = error {
                self?.showAlert("Failed to update email: \(error.localizedDescription)")
                return
            }
            
            self?.updateFirestoreProfile(firstName: firstName, lastName: lastName, phone: phone, email: email)
            
            do {
                try Auth.auth().signOut()
                self?.showAlert("Email updated successfully. You have been signed out.") {
                    self?.navigateToLoginScreen()
                }
            } catch {
                self?.showAlert("Failed to sign out: \(error.localizedDescription)")
            }
        }
    }

    func updateFirestoreProfile(firstName: String, lastName: String, phone: String, email: String) {
        let userData = [
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone,
            "email": email
        ]
        
        db.collection("users").document(userID).setData(userData) { error in
            if let error = error {
                self.showAlert("Failed to save data: \(error.localizedDescription)")
            } else {
                print("User profile updated in Firestore successfully!")
            }
        }
    }

    func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

    func navigateToLoginScreen() {
        // Navigate to the login screen after signing out
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
}
