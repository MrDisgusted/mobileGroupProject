//
//  LoginViewController.swift
//  Lavender
//
//  Created by Carter Stone on 09/12/2024.
//

import UIKit

class LoginViewController: UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?() 
        }))
        present(alert, animated: true, completion: nil)
    }



    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let enteredEmail = emailTextField.text ?? ""
        let enteredPassword = passwordTextField.text ?? ""

            let savedEmail = UserDefaults.standard.string(forKey: "RegisteredEmail") ?? ""
            let savedPassword = UserDefaults.standard.string(forKey: "RegisteredPassword") ?? ""

            if enteredEmail == savedEmail && enteredPassword == savedPassword {
                showAlert(title: "Login Successful", message: "Welcome back!") {
                    self.performSegue(withIdentifier: "goToHomePage", sender: self)
                }
            } else {
                showAlert(title: "Login Failed", message: "Invalid email or password. Please try again.")
            }
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    
    
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
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
