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
        
        if enteredEmail.isEmpty || enteredPassword.isEmpty || enteredAdminID.isEmpty {
            showAlert(title: "Error", message: "All fields are required.")
            return
        }
        
        if enteredAdminID != correctAdminID {
            showAlert(title: "Error", message: "Invalid Admin ID.")
            return
        }
        
        if enteredEmail == "admin@lavendar.com" && enteredPassword == "adminlavendar123" {
            Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { authResult, error in
                if let error = error {
                    self.showAlert(title: "Error", message: "Authentication failed: \(error.localizedDescription)")
                    return
                }
                self.showAlert(title: "Success", message: "Welcome, Admin!") {
                    let storyboard = UIStoryboard(name: "AdminMenu", bundle: nil)
                    if let adminMenuVC = storyboard.instantiateViewController(withIdentifier: "AdminMenuViewController") as? AdminMenuViewController {
                        adminMenuVC.modalPresentationStyle = .fullScreen
                        self.present(adminMenuVC, animated: true, completion: nil)
                    }
                }
            }
        } else {
            showAlert(title: "Error", message: "Invalid email or password.")
        }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
