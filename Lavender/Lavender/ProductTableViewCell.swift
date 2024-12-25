import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var categoryLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!

        override func awakeFromNib() {
            super.awakeFromNib()
                
                guard productImageView != nil else {
                    print("Error: productImageView not connected!")
                    return
                }
                guard titleLabel != nil else {
                    print("Error: titleLabel not connected!")
                    return
                }
                guard categoryLabel != nil else {
                    print("Error: categoryLabel not connected!")
                    return
                }
                guard priceLabel != nil else {
                    print("Error: priceLabel not connected!")
                    return
                }
                
                setupViews()
        }

        private func setupViews() {
            productImageView.contentMode = .scaleAspectFit
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textColor = .white
            categoryLabel.font = UIFont.systemFont(ofSize: 12)
            categoryLabel.textColor = .lightGray
            priceLabel.font = UIFont.systemFont(ofSize: 14)
            priceLabel.textColor = .systemBlue
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            productImageView.widthAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }





}
