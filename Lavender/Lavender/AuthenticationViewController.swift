//
//  AuthenticationViewController.swift
//  Lavender
//
//  Created by Carter Stone on 12/12/2024.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var codeTextField1: UITextField!
    @IBOutlet weak var codeTextField2: UITextField!
    @IBOutlet weak var codeTextField3: UITextField!
    @IBOutlet weak var codeTextField4: UITextField!
    @IBOutlet weak var verifyButton: UIButton!

    let hardcodedCode = "1234"
    var email: String = ""
    var newPassword: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField1.delegate = self
        codeTextField2.delegate = self
        codeTextField3.delegate = self
        codeTextField4.delegate = self
    }

    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        let enteredCode = "\(codeTextField1.text ?? "")\(codeTextField2.text ?? "")\(codeTextField3.text ?? "")\(codeTextField4.text ?? "")"

        if enteredCode == hardcodedCode {
            UserDefaults.standard.set(newPassword, forKey: "RegisteredPassword")
            showAlert(title: "Success", message: "Verification successful. Your password has been changed.") {
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        } else {
            showAlert(title: "Error", message: "Incorrect code. Please try again.")
        }
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }


   

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, (text.count + string.count - range.length) > 1 {
            return false
        }

        if !string.isEmpty {
            textField.text = string
            switch textField {
            case codeTextField1:
                codeTextField2.becomeFirstResponder()
            case codeTextField2:
                codeTextField3.becomeFirstResponder()
            case codeTextField3:
                codeTextField4.becomeFirstResponder()
            case codeTextField4:
                textField.resignFirstResponder()
            default:
                break
            }
            return false
        }

        return true
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


