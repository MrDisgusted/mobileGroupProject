//
//  ProductViewController.swift
//  Lavender
//
//  Created by fawaz on 28/12/2024.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productStatus: UILabel!
    @IBOutlet weak var productArrival: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UIButton!
    var product: Product?
    
    @IBAction func productBuy(_ sender: Any) {
        guard let product = product else {
            print("Product is nil. Cannot add to cart.")
            return
        }

        CartManager.shared.addItem(product)
        print("Added \(product.name) to the cart.")

        UIView.animate(withDuration: 0.2, animations: {
            self.productPrice.backgroundColor = UIColor.green.withAlphaComponent(0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.productPrice.backgroundColor = UIColor.blue
            }
        }
        
        let alert = UIAlertController(
            title: "Added to Cart",
            message: "\(product.name) has been added to your cart.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductDetails()
    }
    
    private func setupProductDetails() {
        guard let product = product else { return }
        
        productName.text = product.name
        productDescription.text = product.description
        productPrice.setTitle("$\(product.price)", for: .normal)
        productStatus.text = product.isAvailable ? "Available" : "Out of Stock"
        productArrival.text = "Will arrive in: " + ("\(product.arrivalDay)") + " days"
        productCategory.text = product.category.toString
        
        
        
        if let imageUrl = String(data: product.image, encoding: .utf8),
           let url = URL(string: imageUrl),
           let imageData = try? Data(contentsOf: url) {
            productImage.image = UIImage(data: imageData)
        } else {
            productImage.image = UIImage(named: "placeholder")
        }
    }
}
