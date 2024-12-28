//
//  CreateStoreAccountViewController.swift
//  Lavender
//
//  Created by Mohamed Nema on 28/12/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateStoreAccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // Data to store user input
    var storeName: String?
    var ownerName: String?
    var storeID: String?
    var category: String?
    var email: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        // Register cell classes (optional if using storyboard)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "storeInfoCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "accountDetailsCell")
    }

    // MARK: - UITableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Store Information and Account Details sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 2 // 4 rows for Store Information, 2 for Account Details
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell", for: indexPath)

        // Configure cells based on section and row
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Store Name"
                let textField = createTextField(placeholder: "Enter store name", tag: 0)
                cell.accessoryView = textField
            case 1:
                cell.textLabel?.text = "Owner Name"
                let textField = createTextField(placeholder: "Enter owner name", tag: 1)
                cell.accessoryView = textField
            case 2:
                cell.textLabel?.text = "Store ID"
                let textField = createTextField(placeholder: "Enter store ID", tag: 2)
                cell.accessoryView = textField
            case 3:
                cell.textLabel?.text = "Category"
                let textField = createTextField(placeholder: "Enter store category", tag: 3)
                cell.accessoryView = textField
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Email"
                let textField = createTextField(placeholder: "Enter email address", tag: 4)
                cell.accessoryView = textField
            case 1:
                cell.textLabel?.text = "Password"
                let textField = createTextField(placeholder: "Enter password", tag: 5)
                cell.accessoryView = textField
            default:
                break
            }
        }

        return cell
    }

    // MARK: - UITableView Delegate Methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Store Information" : "Account Details"
    }

    // MARK: - Helper Method to Create Text Fields
    private func createTextField(placeholder: String, tag: Int) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.tag = tag
        textField.delegate = self
        return textField
    }

    // MARK: - Create Store Account Action
    @IBAction func createStoreAccountButtonTapped(_ sender: UIButton) {
        guard let storeName = storeName, !storeName.isEmpty,
              let ownerName = ownerName, !ownerName.isEmpty,
              let storeID = storeID, !storeID.isEmpty,
              let category = category, !category.isEmpty,
              let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        // Create Store Account in Firebase
        let db = Firestore.firestore()
        let storeData: [String: Any] = [
            "storeName": storeName,
            "ownerName": ownerName,
            "storeID": storeID,
            "category": category,
            "email": email
        ]

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to create account: \(error.localizedDescription)")
                return
            }

            guard let userID = authResult?.user.uid else { return }
            db.collection("stores").document(userID).setData(storeData) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to save store data: \(error.localizedDescription)")
                } else {
                    self.showAlert(title: "Success", message: "Store account created successfully!") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
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

// MARK: - UITextFieldDelegate
extension CreateStoreAccountViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            storeName = textField.text
        case 1:
            ownerName = textField.text
        case 2:
            storeID = textField.text
        case 3:
            category = textField.text
        case 4:
            email = textField.text
        case 5:
            password = textField.text
        default:
            break
        }
    }
}
