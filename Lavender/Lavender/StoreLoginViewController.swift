//
//  AdminLoginViewController.swift
//  Lavender
//
//  Created by Carter Stone on 13/12/2024.
//

import UIKit
import FirebaseFirestore

class StoreLoginViewController: UIViewController {
    @IBOutlet weak var passwordToggleButton: UIButton!
    @IBOutlet weak var storeEmailTextField: UITextField!
    @IBOutlet weak var storePasswordTextField: UITextField!
    @IBOutlet weak var storeIDTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeEmailTextField.attributedPlaceholder = NSAttributedString(
            string: "example@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        storePasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        storeIDTextField.attributedPlaceholder = NSAttributedString(
            string: "123",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        storePasswordTextField.isSecureTextEntry = true
        updatePasswordToggleIcon()
    }
    
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
    
    @IBAction func storeLoginButtonTapped(_ sender: UIButton) {
        let enteredEmail = storeEmailTextField.text ?? ""
           let enteredPassword = storePasswordTextField.text ?? ""
           let enteredStoreID = storeIDTextField.text ?? ""

           if enteredEmail.isEmpty || enteredPassword.isEmpty || enteredStoreID.isEmpty {
               showAlert(title: "Error", message: "All fields are required.")
               return
           }

           let db = Firestore.firestore()
           let storesRef = db.collection("stores")

           storesRef.whereField("email", isEqualTo: enteredEmail)
               .whereField("password", isEqualTo: enteredPassword)
               .whereField("store id", isEqualTo: enteredStoreID)
               .getDocuments { [weak self] snapshot, error in
                   guard let self = self else { return }

                   if let error = error {
                       self.showAlert(title: "Error", message: "An error occurred: \(error.localizedDescription)")
                       return
                   }

                   if let documents = snapshot?.documents, !documents.isEmpty {
                       if let storeData = documents.first?.data(),
                          let storeName = storeData["store name"] as? String {
                           UserDefaults.standard.setValue(storeName, forKey: "loggedInStoreName")
                       }

                       self.showAlert(title: "Success", message: "Welcome, Store Owner!") {
                           let storyboard = UIStoryboard(name: "AddProduct", bundle: nil)
                           let myStoreVC = storyboard.instantiateViewController(withIdentifier: "StoreOwnerLogin")
                           myStoreVC.modalPresentationStyle = .fullScreen
                           self.present(myStoreVC, animated: true, completion: nil)
                       }
                   } else {
                       self.showAlert(title: "Error", message: "Invalid email, password, or store ID.")
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

