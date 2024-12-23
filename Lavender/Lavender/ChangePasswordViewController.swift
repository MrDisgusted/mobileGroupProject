//
//  ChangePasswordViewController.swift
//  Lavender
//
//  Created by Carter Stone on 12/12/2024.
//


import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var passwordToggleButton: UIButton!

    var email: String = "" 

    override func viewDidLoad() {
        super.viewDidLoad()
        newPasswordTextField.isSecureTextEntry = true
        updatePasswordToggleIcon()
    }

    @IBAction func passwordToggleButtonTapped(_ sender: UIButton) {
        newPasswordTextField.isSecureTextEntry.toggle()
        updatePasswordToggleIcon()
    }

    func updatePasswordToggleIcon() {
        let imageName = newPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @IBAction func changePasswordTapped(_ sender: UIButton) {
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter your new password.")
            return
        }

        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to update password: \(error.localizedDescription)")
            } else {
                self.showAlert(title: "Success", message: "Your password has been updated.") {
                    self.performSegue(withIdentifier: "goToLogin", sender: nil)
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

