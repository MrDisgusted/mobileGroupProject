//
//  ChangePasswordViewController.swift
//  Lavender
//
//  Created by Carter Stone on 12/12/2024.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    //pass toggle hidden/not hidden
    @IBOutlet weak var passwordToggleButton: UIButton!
    

    @IBAction func passwordToggleButtonTapped(_ sender: Any) {
        newPasswordTextField.isSecureTextEntry.toggle()
                   let currentText = newPasswordTextField.text
        newPasswordTextField.text = nil
        newPasswordTextField.text = currentText
                   updatePasswordToggleIcon()
        
    }
    func updatePasswordToggleIcon() {
            let imageName = newPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        newPasswordTextField.isSecureTextEntry = true
           updatePasswordToggleIcon()
        emailTextField.attributedPlaceholder = NSAttributedString(
                string: "example@example.com",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        newPasswordTextField.attributedPlaceholder = NSAttributedString(
               string: "Password",
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email.")
            return
        }

        guard let password = newPasswordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter a new password.")
            return
        }

        let registeredEmail = UserDefaults.standard.string(forKey: "RegisteredEmail") ?? ""

        if email == registeredEmail {
            performSegue(withIdentifier: "goToVerification", sender: self)
        } else {
            showAlert(title: "Error", message: "The email you entered is incorrect.")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVerification",
           let destinationVC = segue.destination as? AuthenticationViewController {
            destinationVC.email = emailTextField.text ?? ""
            destinationVC.newPassword = newPasswordTextField.text ?? ""
         
        }
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


