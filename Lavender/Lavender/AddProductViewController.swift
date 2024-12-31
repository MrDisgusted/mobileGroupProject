import UIKit
import FirebaseFirestore

protocol AddProductDelegate: AnyObject {
    func didAddProduct(_ product: [String: Any])
}

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var storeIDTextField: UITextField!
    weak var delegate: AddProductDelegate?
    var uploadedImageUrl: String?
    let db = Firestore.firestore()
    private var hasSelectedImage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = "Product Description"
        descriptionTextView.textColor = .gray
        descriptionTextView.delegate = self
        categoryButton.setTitle("Select Category", for: .normal)
    }

    @IBAction func categoryButtonTapped(_ sender: Any) {
        let categoryAlert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        let categories = ["Bodycare", "Cleaning", "Stationary", "Gardening", "Supplements", "Accessories", "Food", "Hygiene"]
        for category in categories {
            categoryAlert.addAction(UIAlertAction(title: category, style: .default, handler: { [weak self] _ in
                self?.categoryButton.setTitle(category, for: .normal)
            }))
        }
        categoryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(categoryAlert, animated: true)
    }

    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            showErrorAlert("Please enter a product name")
            return
        }

        guard let description = descriptionTextView.text, description != "Product Description",
              !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showErrorAlert("Please enter a product description")
            return
        }

        guard let priceString = priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !priceString.isEmpty, let price = Double(priceString) else {
            showErrorAlert("Please enter a valid price")
            return
        }

        guard let stockString = stockTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !stockString.isEmpty, let stock = Int(stockString) else {
            showErrorAlert("Please enter a valid stock quantity")
            return
        }

        guard let categoryName = categoryButton.titleLabel?.text, categoryName != "Select Category" else {
            showErrorAlert("Please select a category")
            return
        }

        guard let storeID = storeIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !storeID.isEmpty else {
            showErrorAlert("Please enter a valid store ID")
            return
        }

        if hasSelectedImage && uploadedImageUrl == nil {
            showErrorAlert("Please wait for the image to finish uploading")
            return
        }

        guard hasSelectedImage else {
            showErrorAlert("Please select a product image")
            return
        }

        guard let imageUrl = uploadedImageUrl else {
            showErrorAlert("Image upload failed. Please try uploading the image again")
            return
        }

        let productData: [String: Any] = [
            "ID": Int.random(in: 1...99999),
            "name": name,
            "imageUrl": imageUrl,
            "category": categoryName,
            "description": description,
            "price": price,
            "quantity": stock,
            "isAvailable": true,
            "storeID": storeID,
            "arrivalDay": 1
        ]

        let loadingAlert = UIAlertController(title: nil, message: "Saving product...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true)

        db.collection("storeProducts").addDocument(data: productData) { [weak self] error in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    if let error = error {
                        self?.showErrorAlert("Failed to save product: \(error.localizedDescription)")
                    } else {
                        self?.delegate?.didAddProduct(productData)
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Product Description" {
            textView.text = ""
            textView.textColor = .white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Product Description"
            textView.textColor = .gray
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            productImageView.image = selectedImage
            hasSelectedImage = true
            uploadedImageUrl = nil

            let loadingAlert = UIAlertController(title: nil, message: "Uploading image...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = .medium
            loadingIndicator.startAnimating()
            loadingAlert.view.addSubview(loadingIndicator)
            present(loadingAlert, animated: true)

            uploadImageToCloudinary(selectedImage) { [weak self] imageUrl in
                DispatchQueue.main.async {
                    loadingAlert.dismiss(animated: true) {
                        if let imageUrl = imageUrl {
                            self?.uploadedImageUrl = imageUrl
                        } else {
                            self?.showErrorAlert("Image upload failed. Please try again.")
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadImageToCloudinary(_ image: UIImage, completion: @escaping (String?) -> Void) {
        let cloudName = "dya8ndfhj"
        let uploadPreset = "ml_default"

        guard let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload"),
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let secureUrl = json["secure_url"] as? String else {
                completion(nil)
                return
            }

            completion(secureUrl)
        }.resume()
    }

    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
