//
//  SignUpViewController.swift
//  Lavender
//
//  Created by Carter Stone on 10/12/2024.
//

import UIKit

class SignUpViewController: UIViewController {

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        
        UserDefaults.standard.set(username, forKey: "RegisteredUsername")
            UserDefaults.standard.set(email, forKey: "RegisteredEmail")
            UserDefaults.standard.set(password, forKey: "RegisteredPassword")
        
        showAlert(title: "Sign Up Successful", message: "Your account has been created!")
        func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }

    }
    
    @IBAction func alreadyHaveAccountTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromSignUp", sender: self)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
