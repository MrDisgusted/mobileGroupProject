//
//  AdminLoginViewController.swift
//  Lavender
//
//  Created by Carter Stone on 13/12/2024.
//

import UIKit
import FirebaseAuth

class StoreLoginViewController: UIViewController {
    
    @IBOutlet weak var passwordToggleButton: UIButton!
    
    @IBAction func passwordToggleButtonTapped(_ sender: Any) {
        storePasswordTextField.isSecureTextEntry.toggle()
        let currentText = storePasswordTextField.text
        storePasswordTextField.text = nil
        storePasswordTextField.text = currentText
        updatePasswordToggleIcon()
    }
    
    func updatePasswordToggleIcon() {
        let imageName = storePasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBOutlet weak var storeEmailTextField: UITextField!
    @IBOutlet weak var storePasswordTextField: UITextField!
    @IBOutlet weak var storeIDTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
               storeEmailTextField.attributedPlaceholder = NSAttributedString(
                   string: "example@example.com",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
               storePasswordTextField.attributedPlaceholder = NSAttributedString(
                   string: "Password",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
               storeIDTextField.attributedPlaceholder = NSAttributedString(
                   string: "123",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
               storePasswordTextField.isSecureTextEntry = true
               updatePasswordToggleIcon()
    }
    
    @IBAction func storeLoginButtonTapped(_ sender: UIButton) {
        let enteredEmail = storeEmailTextField.text ?? ""
                let enteredPassword = storePasswordTextField.text ?? ""
                let enteredStoreID = storeIDTextField.text ?? ""
                let correctStoreID = "456"

                if enteredEmail.isEmpty || enteredPassword.isEmpty || enteredStoreID.isEmpty {
                    showAlert(title: "Error", message: "All fields are required.")
                    return
                }

                if enteredStoreID != correctStoreID {
                    showAlert(title: "Error", message: "Invalid Store ID.")
                    return
                }

                Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { authResult, error in
                    if let error = error {
                        self.showAlert(title: "Error", message: "Authentication failed: \(error.localizedDescription)")
                        return
                    }

                    self.showAlert(title: "Success", message: "Welcome, Store Owner!") {
                        let storyboard = UIStoryboard(name: "AddProduct", bundle: nil)
                        if let addProductVC = storyboard.instantiateInitialViewController() {
                            addProductVC.modalPresentationStyle = .fullScreen
                            self.present(addProductVC, animated: true, completion: nil)
                        }
                    }
                }
    }

    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completion?()
                }))
                present(alert, animated: true, completion: nil)
            }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

