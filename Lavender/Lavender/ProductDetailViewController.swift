//
//  ProductDetailViewController.swift
//  Lavender
//
//  Created by Carter Stone on 30/12/2024.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ecoBarLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var productDetails: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        populateProductDetails()
    }

    private func populateProductDetails() {
        guard let details = productDetails else { return }

        titleLabel.text = details["name"] as? String ?? "No Title"
        categoryLabel.text = details["category"] as? String ?? "No Category"
        descriptionLabel.text = details["description"] as? String ?? "No Description"
        priceLabel.text = {
            if let price = details["price"] as? Double {
                return String(format: "$%.2f", price)
            }
            return "No Price"
        }()

        ecoBarLabel.text = "Eco-Bar Placeholder"
        statusLabel.text = {
            let isAvailable = details["isAvailable"] as? Bool ?? false
            let arrivalDay = details["arrivalDay"] as? Int ?? 0
            return isAvailable ? "Available, Arrives in \(arrivalDay) days" : "Out of Stock"
        }()

        if let imageUrlString = details["imageUrl"] as? String,
           let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.productImageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            productImageView.image = UIImage(named: "placeholder")
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

}
