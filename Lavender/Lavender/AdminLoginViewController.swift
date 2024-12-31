//
//  AdminLoginViewController.swift
//  Lavender
//
//  Created by Carter Stone on 13/12/2024.
//

import UIKit
import FirebaseAuth

class AdminLoginViewController: UIViewController {

    @IBOutlet weak var passwordToggleButton: UIButton!
    @IBOutlet weak var adminEmailTextField: UITextField!
    @IBOutlet weak var adminPasswordTextField: UITextField!
    @IBOutlet weak var adminIDTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pre-fill placeholders and default values for admin credentials
        adminEmailTextField.text = "admin@example.com" // Pre-filled admin email
        adminPasswordTextField.text = "password123" // Pre-filled admin password
        adminIDTextField.text = "765" // Pre-filled admin ID

        adminEmailTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        adminPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        adminIDTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Admin ID",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )

        adminPasswordTextField.isSecureTextEntry = true
        updatePasswordToggleIcon()
    }
    
    @IBAction func passwordToggleButtonTapped(_ sender: Any) {
        adminPasswordTextField.isSecureTextEntry.toggle()
        let currentText = adminPasswordTextField.text
        adminPasswordTextField.text = nil
        adminPasswordTextField.text = currentText
        updatePasswordToggleIcon()
    }
    
    func updatePasswordToggleIcon() {
        let imageName = adminPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @IBAction func adminLoginButtonTapped(_ sender: UIButton) {
        let enteredEmail = adminEmailTextField.text ?? ""
        let enteredPassword = adminPasswordTextField.text ?? ""
        let enteredAdminID = adminIDTextField.text ?? ""
        let correctAdminID = "765"

        // Validate Admin ID
        if enteredAdminID != correctAdminID {
            showAlert(title: "Error", message: "Invalid Admin ID.")
            return
        }

        // Firebase Authentication
        Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { authResult, error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to login: \(error.localizedDescription)")
                return
            }

            // Check if the logged-in user is the admin
            if let user = Auth.auth().currentUser, user.email == "admin@example.com" {
                // Navigate to Admin Menu
                let storyboard = UIStoryboard(name: "AdminMenu", bundle: nil)
                if let adminMenuVC = storyboard.instantiateViewController(withIdentifier: "AdminMenuViewController") as? AdminMenuViewController {
                    adminMenuVC.modalPresentationStyle = .fullScreen
                    self.present(adminMenuVC, animated: true, completion: nil)
                }
            } else {
                self.showAlert(title: "Error", message: "You are not authorized to access this section.")
                try? Auth.auth().signOut()
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
