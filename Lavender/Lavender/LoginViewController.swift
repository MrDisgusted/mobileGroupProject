import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
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
        setupUI()
    }

    func setupUI() {
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

            if !isValidEmail(enteredEmail) {
                showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
                return
            }

            Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { [weak self] authResult, error in
                if error != nil {
                    self?.failedLoginAttempts += 1
                    if self?.failedLoginAttempts ?? 0 >= 5 {
                        self?.showCaptcha()
                    } else {
                        self?.showAlert(title: "Login Failed", message: "Invalid email or password. Attempt \(self?.failedLoginAttempts ?? 0) of 5.")
                    }
                    return
                }

                self?.failedLoginAttempts = 0
                self?.createUserDocumentIfNeeded(authResult: authResult)

                // Navigate to HomeViewController
                self?.navigateToHomeViewController()
            }
        }

        func navigateToHomeViewController() {
            let storyboard = UIStoryboard(name: "StorePage", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "Store") as? HomeViewController {
                homeVC.modalPresentationStyle = .fullScreen
                present(homeVC, animated: true, completion: nil)
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

    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToVerificationPage", sender: self)
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    
    // MARK: - New Admin Login Button Action
    @IBAction func adminLoginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAdminLogin", sender: self)
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

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

    func createUserDocumentIfNeeded(authResult: AuthDataResult?) {
        guard let userID = authResult?.user.uid, let email = authResult?.user.email else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { document, _ in
            if document?.exists == false {
                let userData = [
                    "firstName": "",
                    "lastName": "",
                    "phone": "",
                    "email": email
                ]

                userRef.setData(userData)
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
