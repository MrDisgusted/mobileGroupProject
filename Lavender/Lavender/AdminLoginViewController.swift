//
//  AdminLoginViewController.swift
//  Lavender
//
//  Created by Carter Stone on 13/12/2024.
//

import UIKit
import FirebaseAuth

class AdminLoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var adminEmailTextField: UITextField!
    @IBOutlet weak var adminPasswordTextField: UITextField!
    @IBOutlet weak var adminIDTextField: UITextField!
    @IBOutlet weak var passwordToggleButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set placeholders
        adminEmailTextField.attributedPlaceholder = NSAttributedString(
            string: "example@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        adminPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        adminIDTextField.attributedPlaceholder = NSAttributedString(
            string: "123",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        // Hide password initially
        adminPasswordTextField.isSecureTextEntry = true
        updatePasswordToggleIcon()
    }

    // MARK: - Actions
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

        // Validate input fields
        if enteredEmail.isEmpty || enteredPassword.isEmpty || enteredAdminID.isEmpty {
            showAlert(title: "Error", message: "All fields are required.")
            return
        }

        // Validate Admin ID
        if enteredAdminID != correctAdminID {
            showAlert(title: "Error", message: "Invalid Admin ID.")
            return
        }

        // Authenticate Admin
        if enteredEmail == "admin@lavender.com" && enteredPassword == "adminlavender123" {
            Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { [weak self] authResult, error in
                if let error = error {
                    self?.showAlert(title: "Error", message: "Authentication failed: \(error.localizedDescription)")
                    return
                }
                
                // Successful login, navigate to Admin Menu
                self?.showAlert(title: "Success", message: "Welcome, Admin!") {
                    self?.navigateToAdminMenu()
                }
            }
        } else {
            showAlert(title: "Error", message: "Invalid email or password.")
        }
    }

    // MARK: - Navigation
    func navigateToAdminMenu() {
        // Instantiate Admin Menu from Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let adminMenuViewController = storyboard.instantiateViewController(withIdentifier: "AdminMenuViewController") as? AdminMenuViewController else {
            showAlert(title: "Error", message: "Unable to load Admin Menu.")
            return
        }
        
        adminMenuViewController.modalPresentationStyle = .fullScreen
        self.present(adminMenuViewController, animated: true, completion: nil)
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
