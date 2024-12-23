//
//  LoginViewController.swift
//  Lavender
//
//  Created by Carter Stone on 09/12/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        print("Forgot Password button tapped")
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordToggleButton: UIButton!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    @IBOutlet weak var captchaQuestionLabel: UILabel!
    @IBOutlet weak var captchaAnswerTextField: UITextField!
    @IBOutlet weak var captchaSubmitButton: UIButton!

    var captchaAnswer: Int = 0
    
    var failedLoginAttempts: Int {
        get {
            return UserDefaults.standard.integer(forKey: "FailedLoginAttempts")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FailedLoginAttempts")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        captchaQuestionLabel.isHidden = true
        captchaAnswerTextField.isHidden = true
        captchaSubmitButton.isHidden = true
        passwordTextField.isSecureTextEntry = true
        updatePasswordToggleIcon()
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "example@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }

    @IBAction func passwordToggleButtonTapped(_ sender: UIButton) {
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

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let enteredEmail = emailTextField.text ?? ""
        let enteredPassword = passwordTextField.text ?? ""

        if enteredEmail.isEmpty || enteredPassword.isEmpty {
            showAlert(title: "Login Failed", message: "Please enter both email and password.")
            return
        }

        // Firebase Login
        Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { authResult, error in
            if let error = error {
                self.failedLoginAttempts += 1
                if self.failedLoginAttempts >= 5 {
                    self.showCaptcha()
                } else {
                    self.showAlert(title: "Login Failed", message: "\(error.localizedDescription) Attempt \(self.failedLoginAttempts) of 5.")
                }
                return
            }

            // Login successful
            self.failedLoginAttempts = 0
            self.showAlert(title: "Login Successful", message: "Welcome back!") {
                self.performSegue(withIdentifier: "goToHomePage", sender: self)
            }
        }
    }

    @IBAction func captchaSubmitTapped(_ sender: UIButton) {
        guard let userAnswer = captchaAnswerTextField.text, let answer = Int(userAnswer) else {
            showAlert(title: "Invalid Input", message: "Please enter a valid number.")
            return
        }
        if answer == captchaAnswer {
            failedLoginAttempts = 0
            captchaQuestionLabel.isHidden = true
            captchaAnswerTextField.isHidden = true
            captchaSubmitButton.isHidden = true
            showAlert(title: "CAPTCHA Solved", message: "You can now try logging in again.")
        } else {
            showAlert(title: "Incorrect CAPTCHA", message: "Please try again.") {
                self.showCaptcha()
            }
        }
    }

    func showCaptcha() {
        let num1 = Int.random(in: 1...10)
        let num2 = Int.random(in: 1...10)
        captchaAnswer = num1 + num2
        captchaQuestionLabel.text = "What is \(num1) + \(num2)?"
        captchaQuestionLabel.isHidden = false
        captchaAnswerTextField.isHidden = false
        captchaSubmitButton.isHidden = false
        captchaAnswerTextField.text = ""
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: self)
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
