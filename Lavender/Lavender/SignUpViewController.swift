//
//  SignUpViewController.swift
//  Lavender
//
//  Created by Carter Stone on 10/12/2024.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }


    // Eye toggle
    @IBOutlet weak var passwordToggleButton: UIButton!
    @IBAction func passwordToggleButtonTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        let currentText = passwordTextField.text
        passwordTextField.text = nil
        passwordTextField.text = currentText
        updatePasswordToggleIcon()
    }

    func updatePasswordToggleIcon() {
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let username = usernameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if username.isEmpty || email.isEmpty || password.isEmpty {
            showAlert(title: "Sign Up Failed", message: "All fields are required. Please fill them out.")
            return
        }

        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                return
            }

            if let user = authResult?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges { error in
                    if let error = error {
                        self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                        return
                    }

                    self.showAlert(title: "Sign Up Successful", message: "Your account has been created!") {
                        // Navigate to the next screen (e.g., login or home screen)
                        self.performSegue(withIdentifier: "goToLoginFromSignUp", sender: self)
                    }
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    @IBAction func alreadyHaveAccountTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromSignUp", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "example@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )

        passwordTextField.isSecureTextEntry = true
        updatePasswordToggleIcon()
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
