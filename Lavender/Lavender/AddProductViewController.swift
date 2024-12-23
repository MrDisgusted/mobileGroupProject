import UIKit

// Delegate Protocol to Pass Product Back
protocol AddProductDelegate: AnyObject {
    func didAddProduct(_ product: Product)
}

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    
    // Delegate to pass data back
    weak var delegate: AddProductDelegate?
    var uploadedImageUrl: String? // Store the Cloudinary image URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the placeholder for the description text view
        descriptionTextView.text = "Product Description"
        descriptionTextView.textColor = .gray
        descriptionTextView.delegate = self
    }
    
    // MARK: - Add Photo Action
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // MARK: - Confirm Button Action
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        // Validate input fields
        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextView.text, description != "Product Description",
              let price = priceTextField.text, !price.isEmpty,
              let stock = stockTextField.text, !stock.isEmpty,
              let imageUrl = uploadedImageUrl else {
            showErrorAlert("Please fill in all fields and upload an image.")
            return
        }
        
        // Create a new product with the Cloudinary image URL
        let newProduct = Product(imageUrl: imageUrl, title: name, category: description, price: price)
        
        // Pass data back using the delegate
        delegate?.didAddProduct(newProduct)
        
        // Dismiss Add Product Page
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextView Delegate (for Placeholder)
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
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            productImageView.image = selectedImage
            
            // Upload the selected image to Cloudinary
            uploadImageToCloudinary(selectedImage) { [weak self] imageUrl in
                DispatchQueue.main.async {
                    if let imageUrl = imageUrl {
                        self?.uploadedImageUrl = imageUrl
                        print("Cloudinary Image URL: \(imageUrl)")
                    } else {
                        self?.showErrorAlert("Image upload failed. Please try again.")
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Upload Image to Cloudinary
    func uploadImageToCloudinary(_ image: UIImage, completion: @escaping (String?) -> Void) {
        let cloudName = "dya8ndfhj" // Your Cloudinary Cloud Name
        let uploadPreset = "ml_default" // Your Upload Preset Name

        guard let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add upload_preset
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)

        // Add image file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)")
            }

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Cloudinary Response: \(json)")
                        if let secureUrl = json["secure_url"] as? String {
                            completion(secureUrl) // Return Cloudinary URL
                        } else if let errorDetails = json["error"] as? [String: Any] {
                            print("Cloudinary Error: \(errorDetails)")
                            completion(nil)
                        } else {
                            print("Unexpected response format.")
                            completion(nil)
                        }
                    }
                } catch {
                    print("Error parsing response: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }.resume()
    }

    
    // MARK: - Helper Method
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
