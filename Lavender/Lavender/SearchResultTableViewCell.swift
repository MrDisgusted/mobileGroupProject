import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceButton: UIButton!

    var product: Product?

    @IBAction func buttonPurchase(_ sender: Any) {
        guard let product = product else { return }
        
        CartManager.shared.addItem(product)

        UIView.animate(withDuration: 0.2, animations: {
            self.productPriceButton.backgroundColor = UIColor.green.withAlphaComponent(0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.productPriceButton.backgroundColor = UIColor.clear
            }
        }

        print("Added to cart: \(product.name)")
    }

    func setupCell(photo: UIImage?, name: String, price: Double, description: String, product: Product) {
        productImageView.image = photo
        productNameLabel.text = name
        productDescriptionLabel.text = description
        productPriceButton.setTitle("$\(price)", for: .normal)
        self.product = product
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
    }
}

