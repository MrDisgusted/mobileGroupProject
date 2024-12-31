

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var ProductDescription: UILabel!
    @IBOutlet weak var ProductPrice: UIButton!
    
    var product: Product?

    @IBAction func buttonPurchase(_ sender: Any) {
        guard let product = product else { return }
        
        // Add the product to the cart
        CartManager.shared.addItem(product)

        // Provide feedback to the user
        UIView.animate(withDuration: 0.2, animations: {
            self.ProductPrice.backgroundColor = UIColor.green.withAlphaComponent(0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.ProductPrice.backgroundColor = UIColor.clear
            }
        }

        print("Added to cart: \(product.name)")
    }


    func setupCell(photo: UIImage?, name: String, price: Double, description: String) {
        ProductImage.image = photo
        ProductName.text = name
        ProductDescription.text = description
        ProductPrice.setTitle("$\(price)", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ProductImage.contentMode = .scaleAspectFill
        ProductImage.clipsToBounds = true
    }
}

