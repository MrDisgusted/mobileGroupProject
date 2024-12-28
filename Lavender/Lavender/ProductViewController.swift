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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductDetails()
    }
    
    private func setupProductDetails() {
        // Ensure product is set before updating UI
        guard let product = product else { return }
        
        // Update UI elements with product data
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
